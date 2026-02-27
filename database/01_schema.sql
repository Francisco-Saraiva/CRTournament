--------------- Views Drops (Correct Order) ---------------

DROP VIEW IF EXISTS v_player_ranking CASCADE;
DROP VIEW IF EXISTS v_player_stats_pct CASCADE;
DROP VIEW IF EXISTS v_deck_winrate_min5 CASCADE;
DROP VIEW IF EXISTS v_cardvariant_rates CASCADE;

--------------- Table Drops (Correct Order) ---------------
-- We drop junction/child tables first to avoid dependency errors
DROP TABLE IF EXISTS Card_CardCategory CASCADE;
DROP TABLE IF EXISTS Deck_CardVariant CASCADE;
DROP TABLE IF EXISTS Match_Player CASCADE;
DROP TABLE IF EXISTS CRGame CASCADE;
DROP TABLE IF EXISTS Match CASCADE;
DROP TABLE IF EXISTS CardVariant CASCADE;
DROP TABLE IF EXISTS Card CASCADE;
DROP TABLE IF EXISTS CardCategory CASCADE;
DROP TABLE IF EXISTS Deck CASCADE;
DROP TABLE IF EXISTS Player CASCADE;
DROP TABLE IF EXISTS CardVariantStats CASCADE;
DROP TABLE IF EXISTS PlayerStats CASCADE;
DROP TABLE IF EXISTS DeckStats CASCADE;
--------------- End of Drops --------------

----------------- Table Creation ---------------

-- 1. Player
CREATE TABLE Player (
    player_id SERIAL PRIMARY KEY,
    player_tag VARCHAR(255) UNIQUE NOT NULL,
    nickname VARCHAR(255) NOT NULL
);

-- 2. Card
CREATE TABLE Card (
    card_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    elixir_cost INT NOT NULL,
    rarity VARCHAR(20) CHECK (rarity IN ('Common', 'Rare', 'Epic', 'Legendary', 'Champion')),
    type VARCHAR(20) CHECK (type IN ('Troop', 'Spell', 'Building', 'Tower Troop'))
);

-- 3. CardVariant (1 Card has 1..3 variants)
CREATE TABLE CardVariant (
    variant_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    variant_type VARCHAR(255) CHECK (variant_type IN ('Normal', 'Evolution', 'Hero')),
    card_id INT NOT NULL,
    FOREIGN KEY (card_id) REFERENCES Card(card_id) ON DELETE CASCADE,
    UNIQUE (name, card_id)
);

-- 4. Deck (1 Player can have many decks)
CREATE TABLE Deck (
    deck_id SERIAL PRIMARY KEY,
    result VARCHAR(255),
    player_id INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

-- 5. Match
CREATE TABLE Match (
    match_id SERIAL PRIMARY KEY,
    round_num INT NOT NULL,
    best_of INT NOT NULL DEFAULT 3,
    winner_player_id INT,
    FOREIGN KEY (winner_player_id) REFERENCES Player(player_id)
);

-- 6. CRGame (1 Match has 1..3 games)
CREATE TABLE CRGame (
    game_id SERIAL PRIMARY KEY,
    game_num INT CHECK (game_num IN (1, 2, 3)),
    player1_crowns INT DEFAULT 0,
    player2_crowns INT DEFAULT 0,
    winner_player_id INT,
    match_id INT NOT NULL,
    player1_deck_id INT,
    player2_deck_id INT,
    stats_processed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (match_id) REFERENCES Match(match_id) ON DELETE CASCADE,
    FOREIGN KEY (winner_player_id) REFERENCES Player(player_id),
    FOREIGN KEY (player1_deck_id) REFERENCES Deck(deck_id),
    FOREIGN KEY (player2_deck_id) REFERENCES Deck(deck_id)
);

-- 7. CardCategory
CREATE TABLE CardCategory (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

--------------- Junction Tables (Many-to-Many) ---------------

-- Many-to-Many: Deck and CardVariant (Each deck has 8-9 cards)
CREATE TABLE Deck_CardVariant (
    deck_id INT REFERENCES Deck(deck_id) ON DELETE CASCADE,
    variant_id INT REFERENCES CardVariant(variant_id) ON DELETE CASCADE,
    PRIMARY KEY (deck_id, variant_id)
);

-- Many-to-Many: Card and CardCategory
CREATE TABLE Card_CardCategory (
    card_id INT REFERENCES Card(card_id) ON DELETE CASCADE,
    category_id INT REFERENCES CardCategory(category_id) ON DELETE CASCADE,
    PRIMARY KEY (card_id, category_id)
);

-- Many-to-Many: Match and Player (Each match has 2 players)
CREATE TABLE Match_Player (
    match_id INT REFERENCES Match(match_id) ON DELETE CASCADE,
    player_id INT REFERENCES Player(player_id) ON DELETE CASCADE,
    PRIMARY KEY (match_id, player_id)
);

CREATE TABLE CardVariantStats (
  variant_id INT PRIMARY KEY REFERENCES CardVariant(variant_id) ON DELETE CASCADE,
  uses INT NOT NULL DEFAULT 0 CHECK (uses >= 0),
  wins INT NOT NULL DEFAULT 0 CHECK (wins >= 0)
);

CREATE TABLE PlayerStats (
  player_id INT PRIMARY KEY REFERENCES Player(player_id) ON DELETE CASCADE,
  games INT NOT NULL DEFAULT 0 CHECK (games >= 0),
  wins INT NOT NULL DEFAULT 0 CHECK (wins >= 0),
  crowns INT NOT NULL DEFAULT 0 CHECK (crowns >= 0)
);

CREATE TABLE DeckStats (
  deck_id INT PRIMARY KEY REFERENCES Deck(deck_id) ON DELETE CASCADE,
  games INT NOT NULL DEFAULT 0 CHECK (games >= 0),
  wins INT NOT NULL DEFAULT 0 CHECK (wins >= 0)
);

---------------- End of Table Creation ---------------