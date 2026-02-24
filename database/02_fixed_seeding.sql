-- 1. Cards (The Parents)
-- We assign IDs manually here so the Variants know exactly where to point
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES 
(1, 'Musketeer', 4, 'Rare', 'Troop'),
(2, 'Giant', 5, 'Rare', 'Troop'),
(3, 'Lumberjack', 4, 'Legendary', 'Troop'),
(4, 'Princess Tower', 0, 'Common', 'Tower Troop');

-- 2. Card Variants (The Children)
-- Musketeer: Normal, Evo, Hero
INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
('Musketeer', 'Normal', 1),
('Evo Musketeer', 'Evolution', 1),
('Hero Musketeer', 'Hero', 1);

-- Giant: Normal, Hero
INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
('Giant', 'Normal', 2),
('Hero Giant', 'Hero', 2);

-- Lumberjack: Normal, Evo
INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
('Lumberjack', 'Normal', 3),
('Evo Lumberjack', 'Evolution', 3);

-- Princess Tower: Normal
INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
('Princess Tower', 'Normal', 4);

SELECT * FROM CardVariant;