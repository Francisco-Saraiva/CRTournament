--! 1. Cards (The Parents)

--* Common Cards (29 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES 
(1, 'Skeletons', 1, 'Common', 'Troop'),
(2, 'Fire Spirit', 1, 'Common', 'Troop'),
(3, 'Electro Spirit', 1, 'Common', 'Troop'),
(4, 'Ice Spirit', 1, 'Common', 'Troop'),
(5, 'Goblins', 2, 'Common', 'Troop'),
(6, 'Spear Goblins', 2, 'Common', 'Troop'),
(7, 'Bomber', 2, 'Common', 'Troop'),
(8, 'Bats', 2, 'Common', 'Troop'),
(9, 'Berserker', 2, 'Common', 'Troop'),
(10, 'Snowball', 2, 'Common', 'Spell'),
(11, 'Zap', 2, 'Common', 'Spell'),
(12, 'Knight', 3, 'Common', 'Troop'),
(13, 'Archers', 3, 'Common', 'Troop'),
(14, 'Minions', 3, 'Common', 'Troop'),
(15, 'Arrows', 3, 'Common', 'Spell'),
(16, 'Cannon', 3, 'Common', 'Building'),
(17, 'Goblin Gang', 3, 'Common', 'Troop'),
(18, 'Skeleton Barrel', 3, 'Common', 'Troop'),
(19, 'Firecracker', 3, 'Common', 'Troop'),
(20, 'Royal Delivery', 3, 'Common', 'Spell'),
(21, 'Skeleton Dragons', 4, 'Common', 'Troop'),
(22, 'Mortar', 4, 'Common', 'Building'),
(23, 'Tesla', 4, 'Common', 'Building'),
(24, 'Barbarians', 5, 'Common', 'Troop'),
(25, 'Minion Horde', 5, 'Common', 'Troop'),
(26, 'Rascals', 5, 'Common', 'Troop'),
(27, 'Royal Giant', 6, 'Common', 'Troop'),
(28, 'Elite Barbarians', 6, 'Common', 'Troop'),
(29, 'Royal Recruits', 7, 'Common', 'Troop')
ON CONFLICT (name) DO NOTHING;

--* Rare Cards (30 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES
(30, 'Heal Spirit', 1, 'Rare', 'Troop'),
(31, 'Ice Golem', 2, 'Rare', 'Troop'),
(32, 'Suspicious Bush', 2, 'Rare', 'Troop'),
(33, 'Tombstone', 3, 'Rare', 'Building'),
(34, 'Dart Goblin', 3, 'Rare', 'Troop'),
(35, 'Earthquake', 3, 'Rare', 'Spell'),
(36, 'Elixir Golem', 3, 'Rare', 'Troop'),
(37, 'Mega Minion', 3, 'Rare', 'Troop'),
(38, 'Musqueteer', 4, 'Rare', 'Troop'),
(39, 'Mini PEKKA', 4, 'Rare', 'Troop'),
(40, 'Goblin Hut', 4, 'Rare', 'Building'),
(41, 'Goblin Cage', 4, 'Rare', 'Building'),
(42, 'Fireball', 4, 'Rare', 'Spell'),
(43, 'Valkyrie', 4, 'Rare', 'Troop'),
(44, 'Battle Ram', 4, 'Rare', 'Troop'),
(45, 'Bomb Tower', 4, 'Rare', 'Building'),
(46, 'Hog Rider', 4, 'Rare', 'Troop'),
(47, 'Flying Machine', 4, 'Rare', 'Troop'),
(48, 'Battle Healer', 4, 'Rare', 'Troop'),
(49, 'Zappies', 4, 'Rare', 'Troop'),
(50, 'Furnace', 4, 'Rare', 'Troop'),
(51, 'Goblin Demolisher', 4, 'Rare', 'Troop'),
(52, 'Giant', 5, 'Rare', 'Troop'),
(53, 'Wizard', 5, 'Rare', 'Troop'),
(54, 'Inferno Tower', 5, 'Rare', 'Building'),
(55, 'Royal Hogs', 5, 'Rare', 'Troop'),
(56, 'Rocket', 6, 'Rare', 'Spell'),
(57, 'Barbarian Hut', 6, 'Rare', 'Building'),
(58, 'Elixir Collector', 6, 'Rare', 'Building'),
(59, 'Three Musketeers', 9, 'Rare', 'Troop')
ON CONFLICT (name) DO NOTHING;

--* Epic Cards (33 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES
(60, 'Mirror', 1, 'Epic', 'Spell'),
(61, 'Barbarian Barrel', 2, 'Epic', 'Spell'),
(62, 'Wall Breakers', 2, 'Epic', 'Troop'),
(63, 'Goblin Curse', 2, 'Epic', 'Spell'),
(64, 'Rage', 2, 'Epic', 'Spell'),
(65, 'Skeleton Army', 3, 'Epic', 'Troop'),
(66, 'Guards', 3, 'Epic', 'Troop'),
(67, 'Goblin Barrel', 3, 'Epic', 'Spell'),
(68, 'Vines', 3, 'Epic', 'Spell'),
(69, 'Tornado', 3, 'Epic', 'Spell'),
(70, 'Clone', 3, 'Epic', 'Spell'),
(71, 'Void', 3, 'Epic', 'Spell'),
(72, 'Baby Dragon', 4, 'Epic', 'Troop'),
(73, 'Dark Prince', 4, 'Epic', 'Troop'),
(74, 'Freeze', 4, 'Epic', 'Spell'),
(75, 'Rune Giant', 4, 'Epic', 'Troop'),
(76, 'Poison', 4, 'Epic', 'Spell'),
(77, 'Hunter', 4, 'Epic', 'Troop'),
(78, 'Goblin Drill', 4, 'Epic', 'Building'),
(79, 'Witch', 5, 'Epic', 'Troop'),
(80, 'Balloon', 5, 'Epic', 'Troop'),
(81, 'Prince', 5, 'Epic', 'Troop'),
(82, 'Electro Dragon', 5, 'Epic', 'Troop'),
(83, 'Bowler', 5, 'Epic', 'Troop'),
(84, 'Executioner', 5, 'Epic', 'Troop'),
(85, 'Cannon Cart', 5, 'Epic', 'Troop'),
(86, 'Giant Skeleton', 6, 'Epic', 'Troop'),
(87, 'Lightning', 6, 'Epic', 'Spell'),
(88, 'Goblin Giant', 6, 'Epic', 'Troop'),
(89, 'X-bow', 6, 'Epic', 'Building'),
(90, 'PEKKA', 7, 'Epic', 'Troop'),
(91, 'Electro Giant', 7, 'Epic', 'Troop'),
(92, 'Golem', 8, 'Epic', 'Troop')
ON CONFLICT (name) DO NOTHING;

--* Legendary Cards (21 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES
(93, 'The Log', 2, 'Legendary', 'Spell'),
(94, 'Princess', 3, 'Legendary', 'Troop'),
(95, 'Miner', 3, 'Legendary', 'Troop'),
(96, 'Ice Wizard', 3, 'Legendary', 'Troop'),
(97, 'Royal Ghost', 3, 'Legendary', 'Troop'),
(98, 'Bandit', 3, 'Legendary', 'Troop'),
(99, 'Fisherman', 3, 'Legendary', 'Troop'),
(100, 'Inferno Dragon', 4, 'Legendary', 'Troop'),
(101, 'Electro Wizard', 4, 'Legendary', 'Troop'),
(102, 'Phoenix', 4, 'Legendary', 'Troop'),
(103, 'Magic Archer', 4, 'Legendary', 'Troop'),
(104, 'Lumberjack', 4, 'Legendary', 'Troop'),
(105, 'Night Witch', 4, 'Legendary', 'Troop'),
(106, 'Mother Witch', 4, 'Legendary', 'Troop'),
(107, 'Ram Rider', 5, 'Legendary', 'Troop'),
(108, 'Graveyard', 5, 'Legendary', 'Spell'),
(109, 'Goblin Machine', 5, 'Legendary', 'Troop'),
(110, 'Sparky', 6, 'Legendary', 'Troop'),
(111, 'Spirit Empress', 6, 'Legendary', 'Troop'),
(112, 'Mega Knight', 7, 'Legendary', 'Troop'),
(113, 'Lava Hound', 7, 'Legendary', 'Troop')
ON CONFLICT (name) DO NOTHING;


--* Champions (8 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES
(114, 'Little Prince', 3, 'Champion', 'Troop'),
(115, 'Skeleton King', 4, 'Champion', 'Troop'),
(116, 'Golden Knight', 4, 'Champion', 'Troop'),
(117, 'Mighty Miner', 4, 'Champion', 'Troop'),
(118, 'Archer Queen', 5, 'Champion', 'Troop'),
(119, 'Monk', 5, 'Champion', 'Troop'),
(120, 'Goblinstein', 5, 'Champion', 'Troop'),
(121, 'Boss Bandit', 6, 'Champion', 'Troop')
ON CONFLICT (name) DO NOTHING;

--* Tower Troops (4 entries)
INSERT INTO Card (card_id, name, elixir_cost, rarity, type) VALUES
(122, 'Tower Princess', 0, 'Common', 'Tower Troop'),
(123, 'Cannoneer', 0, 'Epic', 'Tower Troop'),
(124, 'Dagger Duchess', 0, 'Legendary', 'Tower Troop'),
(125, 'Royal Chef', 0, 'Legendary', 'Tower Troop')
ON CONFLICT (name) DO NOTHING;



--! 2. Card Variants (The Children)
-- Musketeer: Normal, Evo, Hero
-- INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
-- ('Musketeer', 'Normal', 1),
-- ('Evo Musketeer', 'Evolution', 1),
-- ('Hero Musketeer', 'Hero', 1);

-- -- Giant: Normal, Hero
-- INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
-- ('Giant', 'Normal', 2),
-- ('Hero Giant', 'Hero', 2);

-- -- Lumberjack: Normal, Evo
-- INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
-- ('Lumberjack', 'Normal', 3),
-- ('Evo Lumberjack', 'Evolution', 3);

-- -- Princess Tower: Normal
-- INSERT INTO CardVariant (name, variant_type, card_id) VALUES 
-- ('Princess Tower', 'Normal', 4);