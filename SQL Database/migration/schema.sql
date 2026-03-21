CREATE SCHEMA highlandcoffee;
USE highlandcoffee;

-- Branch
CREATE TABLE Branch (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100),
    address VARCHAR(200)
) ENGINE=InnoDB;

-- Customer
CREATE TABLE Customer (
    cust_id INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(50),
    lname VARCHAR(50),
    email VARCHAR(100)
) ENGINE=InnoDB;

-- Customer Profile                          
CREATE TABLE Customer_Profiles (
    cust_id INT PRIMARY KEY,
    birthday DATE,
    point_available FLOAT,
    FOREIGN KEY Customer_Profiles (cust_id) REFERENCES Customer(cust_id)
) ENGINE=InnoDB;


-- Employee
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(50),
    lname VARCHAR(50),
    title VARCHAR(50),
    branch_id INT,
    status VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
) ENGINE=InnoDB;

-- Menu
CREATE TABLE Menu (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100),
    unit_price DECIMAL(10,2),
    unit_type VARCHAR(10),
    category VARCHAR(50)
) ENGINE=InnoDB;

-- Ingredients
CREATE TABLE Ingredients (
    ingredients_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    unit VARCHAR(10)
) ENGINE=InnoDB;

-- Recipe
CREATE TABLE Recipe (
    item_id INT,
    ingredients_id INT,
    quantity VARCHAR(20),

    PRIMARY KEY(item_id, ingredients_id),

    FOREIGN KEY (item_id) REFERENCES Menu(item_id),
    FOREIGN KEY (ingredients_id) REFERENCES Ingredients(ingredients_id)
) ENGINE=InnoDB;

-- Orders (Partitioned by year)
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT,
    cust_id INT,
    order_times DATETIME,
    employee_id INT,
    status VARCHAR(10),

  PRIMARY KEY(order_id),

    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)

) ENGINE=InnoDB;
-- Order Items
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT,
    price DECIMAL(10,2),

    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Menu(item_id)
) ENGINE=InnoDB;
CREATE TABLE Retail_Partners (
    retail_partner_id INT PRIMARY KEY AUTO_INCREMENT,
    partner_name VARCHAR(50),
    contact VARCHAR(50)
);

-- Inventory
CREATE TABLE Inventory (
    branch_id INT,
    ingredients_id INT,
    quantity INT,
    last_updated DATETIME,

    PRIMARY KEY(branch_id, ingredients_id),

    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    FOREIGN KEY (ingredients_id) REFERENCES Ingredients(ingredients_id)
) ENGINE=InnoDB;

-- Payment
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    branch_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(20),

    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
) ENGINE=InnoDB;

-- Supplier
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100),
    address VARCHAR(200)
) ENGINE=InnoDB;

-- Supplier Ingredients
CREATE TABLE Supplier_Ingredients (
    supplier_id INT,
    ingredients_id INT,
    unit_price DECIMAL(10,2),
    lead_time VARCHAR(50),

    PRIMARY KEY(supplier_id, ingredients_id),

    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (ingredients_id) REFERENCES Ingredients(ingredients_id)
) ENGINE=InnoDB;

-- Retail Orders
CREATE TABLE Retail_Orders (
    replenish_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT,
    order_date DATETIME,
    status VARCHAR(10),

    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
) ENGINE=InnoDB;

-- Retail Order Items
CREATE TABLE Retail_Order_Items (
    replenish_id INT,
    ingredients_id INT,
    quantity VARCHAR(20),

    PRIMARY KEY(replenish_id, ingredients_id),

    FOREIGN KEY (replenish_id) REFERENCES Retail_Orders(replenish_id),
    FOREIGN KEY (ingredients_id) REFERENCES Ingredients(ingredients_id)
) ENGINE=InnoDB;

-- Receipts
CREATE TABLE Receipts (
    receipt_id INT PRIMARY KEY AUTO_INCREMENT,
    replenish_id INT,
    retail_partner_id INT,
    actual_quantity VARCHAR(20),
    received_date DATETIME,

   FOREIGN KEY (retail_partner_id) REFERENCES Retail_Partners(retail_partner_id)
) ENGINE=InnoDB;

-- External Partners
CREATE TABLE External_Partners (
    ext_partner_id INT PRIMARY KEY AUTO_INCREMENT,
    partner_name VARCHAR(50),
    commission_rate DECIMAL(5,2),
    contact VARCHAR(50)
) ENGINE=InnoDB;

-- External Orders
CREATE TABLE External_Orders (
    order_id INT,
    ext_partner_id INT,
    external_ref_id VARCHAR(50),

    PRIMARY KEY(order_id, ext_partner_id),

    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (ext_partner_id) REFERENCES External_Partners(ext_partner_id)
) ENGINE=InnoDB;


CREATE TABLE Active_Orders (
    order_id INT PRIMARY KEY,
    status VARCHAR(10),
    estimated_time VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE INDEX idx_orders_customer
ON Orders(cust_id);

CREATE INDEX idx_orders_employee
ON Orders(employee_id);

CREATE INDEX idx_orders_time
ON Orders(order_times);

CREATE INDEX idx_order_items_order
ON Order_Items(order_id);

CREATE INDEX idx_order_items_item
ON Order_Items(item_id);

CREATE INDEX idx_inventory_branch_ingredient
ON Inventory(branch_id, ingredients_id);

CREATE INDEX idx_menu_category
ON Menu(category);

CREATE INDEX idx_payment_order
ON Payment(order_id);

CREATE INDEX idx_payment_date
ON Payment(payment_date);

CREATE INDEX idx_retail_orders_branch
ON Retail_Orders(branch_id);
