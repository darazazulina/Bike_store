create database bike_store;

CREATE TABLE bike_store.stores (
	store_id INT NOT NULL AUTO_INCREMENT,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5),
    PRIMARY KEY (store_id)
);

CREATE TABLE bike_store.staffs (
	staff_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active INT NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
    PRIMARY KEY (staff_id),
	FOREIGN KEY (store_id) 
        REFERENCES bike_store.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) 
        REFERENCES bike_store.staffs (staff_id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE bike_store.categories (
	category_id INT NOT NULL AUTO_INCREMENT,
	category_name VARCHAR (255) NOT NULL,
    PRIMARY KEY (category_id)
);

CREATE TABLE bike_store.brands (
	brand_id INT NOT NULL AUTO_INCREMENT,
	brand_name VARCHAR (255) NOT NULL,
    PRIMARY KEY (brand_id)
);

CREATE TABLE bike_store.products (
	product_id INT NOT NULL AUTO_INCREMENT,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
    PRIMARY KEY (product_id),
	FOREIGN KEY (category_id) 
        REFERENCES bike_store.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) 
        REFERENCES bike_store.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bike_store.customers (
	customer_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5),
    PRIMARY KEY (customer_id)
);

CREATE TABLE bike_store.orders (
	order_id INT NOT NULL AUTO_INCREMENT,
	customer_id INT,
	order_status INT NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
    PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) 
        REFERENCES bike_store.customers (customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) 
        REFERENCES bike_store.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) 
        REFERENCES bike_store.staffs (staff_id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE bike_store.order_items(
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) 
        REFERENCES bike_store.orders (order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) 
        REFERENCES bike_store.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bike_store.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) 
        REFERENCES bike_store.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) 
        REFERENCES bike_store.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);










