-- =====================================
-- Recipe Manager DBMS - Triggers & Procedures
-- =====================================

DELIMITER $$

-- Trigger 1: Auto add cooking history when meal plan is added
CREATE TRIGGER after_meal_logged
AFTER INSERT ON Meal_Plan
FOR EACH ROW
BEGIN
    INSERT INTO Cooking_History(user_id, recipe_id, cooked_date)
    VALUES(NEW.user_id, NEW.recipe_id, NEW.plan_date);
END $$

DELIMITER ;

-- =====================================

DELIMITER $$

-- Trigger 2: Update pantry after cooking
CREATE TRIGGER update_pantry_after_cook
AFTER INSERT ON Cooking_History
FOR EACH ROW
BEGIN
    UPDATE Pantry p
    JOIN Recipe_Ingredients ri 
        ON p.ingredient_id = ri.ingredient_id
    SET p.quantity = p.quantity - ri.quantity
    WHERE ri.recipe_id = NEW.recipe_id
      AND p.user_id = NEW.user_id;
END $$

DELIMITER ;

-- =====================================

-- Table for expiry alerts
CREATE TABLE IF NOT EXISTS Expiry_Alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ingredient_id INT,
    message VARCHAR(255)
);

DELIMITER $$

-- Trigger 3: Check expiry of ingredients
CREATE TRIGGER check_expiry
AFTER INSERT ON Pantry
FOR EACH ROW
BEGIN
    IF NEW.expiry_date <= CURDATE() + INTERVAL 3 DAY THEN
        INSERT INTO Expiry_Alerts(user_id, ingredient_id, message)
        VALUES(NEW.user_id, NEW.ingredient_id, 'Ingredient expiring soon');
    END IF;
END $$

DELIMITER ;

-- =====================================

-- Table for recommendations
CREATE TABLE IF NOT EXISTS Recommendations (
    rec_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    message VARCHAR(255)
);

DELIMITER $$

-- Trigger 4: Suggest recipes when ingredient added
CREATE TRIGGER suggest_recipe_after_pantry
AFTER INSERT ON Pantry
FOR EACH ROW
BEGIN
    INSERT INTO Recommendations(user_id, recipe_id, message)
    SELECT NEW.user_id, ri.recipe_id,
    'You can cook this recipe with your new ingredient!'
    FROM Recipe_Ingredients ri
    WHERE ri.ingredient_id = NEW.ingredient_id;
END $$

DELIMITER ;

-- =====================================

DELIMITER $$

-- Trigger 5: Prevent duplicate ingredients in recipe
CREATE TRIGGER prevent_duplicate_recipe
BEFORE INSERT ON Recipe_Ingredients
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Recipe_Ingredients
        WHERE recipe_id = NEW.recipe_id
        AND ingredient_id = NEW.ingredient_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate ingredient not allowed';
    END IF;
END $$

DELIMITER ;

-- =====================================

-- Stored Procedure 1: Generate weekly meal plan
DELIMITER $$

CREATE PROCEDURE generate_weekly_meal_plan(IN uid INT)
BEGIN
    INSERT INTO Meal_Plan(user_id, recipe_id, plan_date)
    SELECT uid, recipe_id, CURDATE() + INTERVAL FLOOR(RAND()*7) DAY
    FROM Recipes
    ORDER BY RAND()
    LIMIT 7;
END $$

DELIMITER ;

-- =====================================

-- Stored Procedure 2: Update trending recipes
CREATE TABLE IF NOT EXISTS Trending (
    recipe_id INT PRIMARY KEY,
    week_start DATE
);

DELIMITER $$

CREATE PROCEDURE update_trending()
BEGIN
    DELETE FROM Trending;

    INSERT INTO Trending(recipe_id, week_start)
    SELECT recipe_id, CURDATE()
    FROM (
        SELECT recipe_id, COUNT(*) AS views
        FROM Recipe_Views
        WHERE view_date >= CURDATE() - INTERVAL 7 DAY
        GROUP BY recipe_id
        ORDER BY views DESC
        LIMIT 5
    ) t;
END $$

DELIMITER ;

-- =====================================

-- Stored Procedure 3: Weekly notification
CREATE TABLE IF NOT EXISTS Weekly_Notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message VARCHAR(255)
);

DELIMITER $$

CREATE PROCEDURE send_weekly_summary()
BEGIN
    INSERT INTO Weekly_Notifications(user_id, message)
    SELECT user_id,
    'Check out this week trending recipes!'
    FROM Users;
END $$

DELIMITER ;