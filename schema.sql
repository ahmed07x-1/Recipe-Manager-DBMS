-- =====================================
-- Recipe Manager DBMS - Schema
-- =====================================

CREATE DATABASE recipe_manager;
USE recipe_manager;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    diet_preference VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recipes Table
CREATE TABLE Recipes (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50),
    difficulty_level VARCHAR(20),
    prep_time INT,
    cooking_method VARCHAR(50),
    is_vegetarian BOOLEAN,
    is_gluten_free BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Ingredients Table
CREATE TABLE Ingredients (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(100) UNIQUE,
    unit VARCHAR(20)
);

-- Recipe Ingredients (Bridge Table)
CREATE TABLE Recipe_Ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity DECIMAL(6,2),
    PRIMARY KEY(recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);

-- Pantry Table
CREATE TABLE Pantry (
    pantry_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    ingredient_id INT,
    quantity DECIMAL(6,2),
    expiry_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE
);

-- Favorites Table
CREATE TABLE Favorites (
    user_id INT,
    recipe_id INT,
    PRIMARY KEY(user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE
);

-- Cooking History Table
CREATE TABLE Cooking_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    cooked_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id)
);

-- Nutrition Table
CREATE TABLE Nutrition (
    recipe_id INT PRIMARY KEY,
    calories INT,
    protein DECIMAL(6,2),
    fats DECIMAL(6,2),
    carbs DECIMAL(6,2),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id) ON DELETE CASCADE
);

-- Meal Plan Table
CREATE TABLE Meal_Plan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    plan_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id)
);

-- Unique constraint for recipes
ALTER TABLE Recipes
ADD CONSTRAINT unique_recipe UNIQUE(user_id, recipe_name);

-- Recipe Views Table
CREATE TABLE Recipe_Views (
    view_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    view_date DATE,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id)
);