-- ===============================
-- Recipe Manager - Queries File
-- ===============================

-- Task 1 — Recipes that can be made using ingredients in the user’s pantry

SELECT r.recipe_id, r.recipe_name
FROM Recipes r
WHERE NOT EXISTS (
    SELECT 1
    FROM Recipe_Ingredients ri
    WHERE ri.recipe_id = r.recipe_id
    AND ri.ingredient_id NOT IN
    (SELECT ingredient_id FROM Pantry WHERE user_id = 1)
);

-- Task 2 — Most popular recipes based on ratings

SELECT r.recipe_name,
       ROUND(AVG(rv.rating),2) AS average_rating,
       COUNT(rv.review_id) AS total_reviews
FROM Recipes r
JOIN Reviews rv ON r.recipe_id = rv.recipe_id
GROUP BY r.recipe_id
ORDER BY average_rating DESC, total_reviews DESC;

-- Task 3 — Vegetarian recipes under 30 minutes

SELECT recipe_name, prep_time
FROM Recipes
WHERE is_vegetarian = TRUE
AND prep_time < 30;

-- Task 4 — High protein & low carbohydrate recipes

SELECT r.recipe_name
FROM Recipes r
JOIN Nutrition n ON r.recipe_id = n.recipe_id
WHERE n.protein >= 20
AND n.carbs <= 10;

-- Task 5 — Top 5 most viewed recipes (last 7 days)

SELECT recipe_id, COUNT(*) AS total_views
FROM Recipe_Views
WHERE view_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY recipe_id
ORDER BY total_views DESC
LIMIT 5;

-- Task 6 — Recipes that require NO cooking

SELECT recipe_name
FROM Recipes
WHERE cooking_method = 'No Cook';

-- Task 7 — Recipes added by a specific user

SELECT r.recipe_name, u.username
FROM Recipes r
JOIN Users u ON r.user_id = u.user_id
WHERE u.user_id = 1;

-- Task 8 — User who shared the most recipes

SELECT u.username, COUNT(r.recipe_id) AS total_recipes
FROM Users u
JOIN Recipes r ON u.user_id = r.user_id
GROUP BY u.user_id
ORDER BY total_recipes DESC
LIMIT 1;

-- Task 9 — Ingredients required for a meal plan

SELECT mp.plan_date, r.recipe_name, i.ingredient_name, ri.quantity
FROM Meal_Plan mp
JOIN Recipes r ON mp.recipe_id = r.recipe_id
JOIN Recipe_Ingredients ri ON r.recipe_id = ri.recipe_id
JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE mp.user_id = 1;

-- Task 10 — Recipes with missing ingredients in pantry

SELECT DISTINCT r.recipe_name
FROM Recipes r
JOIN Recipe_Ingredients ri ON r.recipe_id = ri.recipe_id
WHERE ri.ingredient_id NOT IN (
    SELECT ingredient_id
    FROM Pantry
    WHERE user_id = 1
);

-- Task 11 — Average prep time of dessert recipes

SELECT AVG(prep_time) AS avg_prep_time
FROM Recipes
WHERE cuisine_type = 'Dessert';

-- Task 12 — Gluten-free recipes with rating > 4

SELECT r.recipe_name, AVG(rv.rating) AS avg_rating
FROM Recipes r
JOIN Reviews rv ON r.recipe_id = rv.recipe_id
WHERE r.is_gluten_free = TRUE
GROUP BY r.recipe_id
HAVING avg_rating > 4;

-- Task 13 — Recipes using a specific ingredient (Avocado)

SELECT r.recipe_name
FROM Recipes r
JOIN Recipe_Ingredients ri ON r.recipe_id = ri.recipe_id
JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE i.ingredient_name = 'Avocado';

-- Task 14 — Cooking history of a specific user

SELECT u.username, r.recipe_name, ch.cooked_date
FROM Cooking_History ch
JOIN Users u ON ch.user_id = u.user_id
JOIN Recipes r ON ch.recipe_id = r.recipe_id
WHERE u.user_id = 1
ORDER BY ch.cooked_date DESC;

-- Task 15 — Users with more than 50 favorite recipes

SELECT u.username, COUNT(f.recipe_id) AS total_favorites
FROM Users u
JOIN Favorites f ON u.user_id = f.user_id
GROUP BY u.user_id
HAVING total_favorites > 50;

-- Task 16 — Most common cooking method

SELECT cooking_method, COUNT(*) AS total
FROM Recipes
GROUP BY cooking_method
ORDER BY total DESC
LIMIT 1;