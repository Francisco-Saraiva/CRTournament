CREATE VIEW v_cardvariant_rates AS
SELECT
  cvs.variant_id,
  cvs.uses,
  cvs.wins,
  CASE WHEN cvs.uses=0 THEN 0 ELSE cvs.wins::float/cvs.uses END AS win_rate
FROM CardVariantStats cvs;

CREATE OR REPLACE VIEW v_deck_winrate AS
SELECT
  ds.deck_id,
  ds.games,
  ds.wins,
  (ds.wins::float / NULLIF(ds.games, 0)) AS win_rate
FROM DeckStats ds

CREATE OR REPLACE VIEW v_player_stats_pct AS
SELECT
  p.player_id,
  p.player_tag,
  p.nickname,
  ps.games,
  ps.wins,
  ps.crowns,
  100.0 * (ps.wins::float / NULLIF(ps.games, 0)) AS win_rate_pct
FROM Player p
JOIN PlayerStats ps ON ps.player_id = p.player_id;

CREATE OR REPLACE VIEW v_player_ranking AS
SELECT
  s.*,
  RANK() OVER (
    ORDER BY
      s.win_rate_pct DESC,
      s.crowns DESC,
      s.wins DESC
  ) AS rank_pos
FROM v_player_stats_pct s;

CREATE OR REPLACE VIEW v_cardvariant_rates_full AS
WITH total_games AS (
  SELECT (SUM(games)::float / 2.0) AS total
  FROM DeckStats
)
SELECT
  cvs.variant_id,
  cvs.uses,
  cvs.wins,
  CASE WHEN cvs.uses = 0 THEN 0 ELSE cvs.wins::float / cvs.uses END AS win_rate,
  CASE WHEN tg.total = 0 THEN 0 ELSE cvs.uses::float / tg.total END AS use_rate
FROM CardVariantStats cvs
CROSS JOIN total_games tg;