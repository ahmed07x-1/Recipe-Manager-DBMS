-- =====================================
-- Recipe Manager DBMS - Sample Data
-- =====================================

-- Users
INSERT INTO Users(username,email,password_hash,diet_preference) VALUES
('Ahmed','ahmed@gmail.com','123','High Protein'),
('Sara','sara@gmail.com','123','Vegetarian'),
('John','john@gmail.com','123','Keto'),
('Aisha','aisha@gmail.com','123','Gluten Free'),
('Rahul','rahul@gmail.com','123','Balanced'),
('Maya','maya@gmail.com','123','Vegan');

-- Ingredients
INSERT INTO Ingredients(ingredient_name,unit) VALUES
('Egg','pieces'),
('Milk','ml'),
('Chicken','grams'),
('Rice','grams'),
('Tomato','grams'),
('Onion','grams'),
('Avocado','grams');

-- Recipes
INSERT INTO Recipes(user_id,recipe_name,cuisine_type,difficulty_level,prep_time,cooking_method,is_vegetarian,is_gluten_free)
VALUES
(1,'Omelette','Breakfast','Easy',10,'Fry',TRUE,TRUE),
(2,'Veg Fried Rice','Chinese','Medium',25,'Stir Fry',TRUE,TRUE),
(3,'Chicken Curry','Indian','Hard',45,'Cook',FALSE,TRUE),
(4,'Avocado Salad','Salad','Easy',5,'No Cook',TRUE,TRUE),
(5,'Grilled Chicken','Dinner','Medium',30,'Grill',FALSE,TRUE),
(6,'Tomato Soup','Soup','Easy',20,'Boil',TRUE,TRUE);

-- Recipe Ingredients
INSERT INTO Recipe_Ingredients VALUES
(1,1,2),(1,2,50),(1,6,20),
(2,4,100),(2,5,50),(2,6,30),
(3,3,200),(3,5,50),(3,6,40),
(4,7,100),(4,5,30),
(5,3,250),(5,6,20),
(6,5,150),(6,6,40),(6,2,50);

-- Pantry
INSERT INTO Pantry(user_id,ingredient_id,quantity,expiry_date) VALUES
(1,1,6,'2026-02-25'),
(1,2,200,'2026-02-20'),
(1,5,200,'2026-02-22'),
(1,6,100,'2026-02-23'),
(1,7,100,'2026-02-24');

-- Reviews
INSERT INTO Reviews(user_id,recipe_id,rating,comment,review_date) VALUES
(2,1,5,'Very tasty','2026-02-01'),
(3,1,4,'Good breakfast','2026-02-02'),
(4,2,4,'Nice flavor','2026-02-03'),
(5,3,5,'Excellent','2026-02-05'),
(6,4,5,'Healthy and fresh','2026-02-06'),
(2,5,4,'Juicy chicken','2026-02-07');

-- Nutrition
INSERT INTO Nutrition VALUES
(1,250,18,12,2),
(2,350,8,5,60),
(3,500,30,20,8),
(4,180,4,15,6),
(5,420,35,18,0),
(6,150,5,3,12);

-- Favorites
INSERT INTO Favorites VALUES
(1,1),(1,4),(1,6),
(2,1),(3,3),(4,5),(5,2);

-- Cooking History
INSERT INTO Cooking_History(user_id,recipe_id,cooked_date) VALUES
(1,1,'2026-02-10'),
(1,4,'2026-02-11'),
(2,2,'2026-02-12'),
(3,3,'2026-02-12'),
(4,5,'2026-02-13');

-- Meal Plan
INSERT INTO Meal_Plan(user_id,recipe_id,plan_date) VALUES
(1,1,'2026-02-17'),
(1,4,'2026-02-18'),
(1,6,'2026-02-19');