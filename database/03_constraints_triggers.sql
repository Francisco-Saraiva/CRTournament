-- Validates deck size and base composition (1 Tower Troop + 8 non-Tower, without card_id repetitions)

CREATE OR REPLACE FUNCTION check_deck_composition(p_deck_id INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_total INT;
  v_tower INT;
  v_non_tower INT;
  v_distinct_cards INT;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM Deck_CardVariant dcv
  WHERE dcv.deck_id = p_deck_id;
  
  IF v_total > 9 THEN
    RAISE EXCEPTION 'Deck % inválido: tem % cartas (máximo 9)', p_deck_id, v_total;
  END IF;

  SELECT COUNT(*)
  INTO v_tower
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type = 'Tower Troop';

  SELECT COUNT(*)
  INTO v_non_tower
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type <> 'Tower Troop';

  SELECT COUNT(DISTINCT cv.card_id)
  INTO v_distinct_cards
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type <> 'Tower Troop';

  IF v_total = 9 THEN
    IF v_tower <> 1 THEN
      RAISE EXCEPTION 'Deck % inválido: tem % Tower Troop(s); esperado 1', p_deck_id, v_tower;
    END IF;

    IF v_non_tower <> 8 THEN
      RAISE EXCEPTION 'Deck % inválido: tem % cartas não-tower; esperado 8', p_deck_id, v_non_tower;
    END IF;

    IF v_distinct_cards <> 8 THEN
      RAISE EXCEPTION 'Deck % inválido: cartas repetidas (mesmo card_id em variantes diferentes ou duplicadas)', p_deck_id;
    END IF;
  END IF;

END;
$$;

-- Validates special deck rules related to Evolution/Hero/Champion cards

CREATE OR REPLACE FUNCTION check_deck_special_rules(p_deck_id INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_total INT;
  v_evos INT;
  v_heroes INT;
  v_champs INT;
BEGIN
  SELECT COUNT(*)
  INTO v_total
  FROM Deck_CardVariant
  WHERE deck_id = p_deck_id;

  IF v_total <> 9 THEN
    RETURN;
  END IF;

  SELECT COUNT(*)
  INTO v_evos
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type <> 'Tower Troop'
    AND cv.variant_type = 'Evolution';

  SELECT COUNT(*)
  INTO v_heroes
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type <> 'Tower Troop'
    AND cv.variant_type = 'Hero';

  SELECT COUNT(*)
  INTO v_champs
  FROM Deck_CardVariant dcv
  JOIN CardVariant cv ON cv.variant_id = dcv.variant_id
  JOIN Card c ON c.card_id = cv.card_id
  WHERE dcv.deck_id = p_deck_id
    AND c.type <> 'Tower Troop'
    AND c.rarity = 'Champion';

  IF v_evos = 0 AND v_heroes = 0 AND v_champs = 0 THEN
    RETURN;
  END IF;

  IF NOT (
      (v_evos = 2 AND ((v_champs = 1 AND v_heroes = 0) OR (v_champs = 0 AND v_heroes = 1)))
      OR
      (v_evos = 1 AND (
          (v_heroes = 1 AND v_champs = 1)
          OR (v_heroes = 2 AND v_champs = 0)
          OR (v_heroes = 0 AND v_champs = 2)
      ))
  )
  THEN
    RAISE EXCEPTION
      'Deck % inválido (regras especiais): evos=%, heroes=%, champs=%',
      p_deck_id, v_evos, v_heroes, v_champs;
  END IF;
END;
$$;

-- Trigger to validate deck composition after adding/updating/deleting cards.

CREATE OR REPLACE FUNCTION trg_deck_cardvariant_validate()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP IN ('INSERT', 'UPDATE') THEN
    PERFORM check_deck_composition(NEW.deck_id);
    PERFORM check_deck_special_rules(NEW.deck_id);
  ELSIF TG_OP = 'DELETE' THEN
    PERFORM check_deck_composition(OLD.deck_id);
    PERFORM check_deck_special_rules(OLD.deck_id);
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$;

-- Allow the full deck composition 

CREATE TRIGGER deck_cardvariant_validate
AFTER INSERT OR UPDATE OR DELETE ON Deck_CardVariant
FOR EACH ROW
EXECUTE FUNCTION trg_deck_cardvariant_validate();

-- Update stats after a game is completed (winner_player_id and crowns are set)

CREATE OR REPLACE FUNCTION apply_crgame_stats(p_game_id INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  g RECORD;
  p1_id INT;
  p2_id INT;
  winner_deck_id INT;
BEGIN
  SELECT *
  INTO g
  FROM CRGame
  WHERE game_id = p_game_id;

  IF g.winner_player_id IS NULL
     OR g.player1_deck_id IS NULL
     OR g.player2_deck_id IS NULL
  THEN
    RETURN;
  END IF;

  IF g.stats_processed THEN
    RETURN;
  END IF;

  SELECT player_id INTO p1_id FROM Deck WHERE deck_id = g.player1_deck_id;
  SELECT player_id INTO p2_id FROM Deck WHERE deck_id = g.player2_deck_id;

  IF p1_id IS NULL OR p2_id IS NULL THEN
    RAISE EXCEPTION 'CRGame % inválido: deck sem player associado', p_game_id;
  END IF;

  INSERT INTO PlayerStats(player_id, games, wins, crowns)
  VALUES (p1_id, 0, 0, 0)
  ON CONFLICT (player_id) DO NOTHING;

  INSERT INTO PlayerStats(player_id, games, wins, crowns)
  VALUES (p2_id, 0, 0, 0)
  ON CONFLICT (player_id) DO NOTHING;

  UPDATE PlayerStats
  SET games = games + 1,
      crowns = crowns + COALESCE(g.player1_crowns, 0),
      wins = wins + CASE WHEN g.winner_player_id = p1_id THEN 1 ELSE 0 END
  WHERE player_id = p1_id;

  UPDATE PlayerStats
  SET games = games + 1,
      crowns = crowns + COALESCE(g.player2_crowns, 0),
      wins = wins + CASE WHEN g.winner_player_id = p2_id THEN 1 ELSE 0 END
  WHERE player_id = p2_id;

  INSERT INTO DeckStats(deck_id, games, wins)
  VALUES (g.player1_deck_id, 0, 0)
  ON CONFLICT (deck_id) DO NOTHING;

  INSERT INTO DeckStats(deck_id, games, wins)
  VALUES (g.player2_deck_id, 0, 0)
  ON CONFLICT (deck_id) DO NOTHING;

  UPDATE DeckStats
  SET games = games + 1,
      wins = wins + CASE WHEN g.winner_player_id = p1_id THEN 1 ELSE 0 END
  WHERE deck_id = g.player1_deck_id;

  UPDATE DeckStats
  SET games = games + 1,
      wins = wins + CASE WHEN g.winner_player_id = p2_id THEN 1 ELSE 0 END
  WHERE deck_id = g.player2_deck_id;

  winner_deck_id :=
    CASE
      WHEN g.winner_player_id = p1_id THEN g.player1_deck_id
      WHEN g.winner_player_id = p2_id THEN g.player2_deck_id
      ELSE NULL
    END;

  IF winner_deck_id IS NULL THEN
    RAISE EXCEPTION 'CRGame % inválido: winner_player_id não corresponde a nenhum player dos decks', p_game_id;
  END IF;

  INSERT INTO CardVariantStats(variant_id, uses, wins)
  SELECT dcv.variant_id, 0, 0
  FROM Deck_CardVariant dcv
  WHERE dcv.deck_id IN (g.player1_deck_id, g.player2_deck_id)
  ON CONFLICT (variant_id) DO NOTHING;

  UPDATE CardVariantStats cvs
  SET uses = cvs.uses + x.cnt
  FROM (
    SELECT variant_id, COUNT(*)::int AS cnt
    FROM Deck_CardVariant
    WHERE deck_id IN (g.player1_deck_id, g.player2_deck_id)
    GROUP BY variant_id
  ) x
  WHERE x.variant_id = cvs.variant_id;

  UPDATE CardVariantStats cvs
  SET wins = wins + 1
  FROM Deck_CardVariant dcv
  WHERE dcv.variant_id = cvs.variant_id
    AND dcv.deck_id = winner_deck_id;

  UPDATE CRGame
  SET stats_processed = TRUE
  WHERE game_id = p_game_id;
END;
$$;

-- Validate deck composition after adding/updating/deleting cards on players.

CREATE OR REPLACE FUNCTION trg_crgame_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM apply_crgame_stats(COALESCE(NEW.game_id, OLD.game_id));
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS crgame_stats_trigger ON CRGame;

-- Update stats after a game is completed (winner_player_id and crowns are set)

CREATE TRIGGER crgame_stats_trigger
AFTER INSERT OR UPDATE OF winner_player_id, player1_deck_id, player2_deck_id, player1_crowns, player2_crowns
ON CRGame
FOR EACH ROW
EXECUTE FUNCTION trg_crgame_stats();