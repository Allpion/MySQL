/* В базе данных shop и sample присутствуют одни и те же таблицы,
 учебной базы данных. Переместите запись id = 1 из таблицы shop.users
 в таблицу sample.users. Используйте транзакции. */

USE shop;
SELECT id, name FROM users;

id|name     |
--+---------+
 1|Геннадий |
 2|Наталья  |
 3|Александр|
 4|Сергей   |
 5|Иван     |
 6|Мария    |
 
USE sample; 
SELECT id, name FROM users;

id|name|
--+----+ 

START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE id = 1);
DELETE FROM shop.users WHERE id = 1;
COMMIT;

USE shop;
SELECT id, name FROM users;

id|name     |
--+---------+
 2|Наталья  |
 3|Александр|
 4|Сергей   |
 5|Иван     |
 6|Мария    |
 
USE sample;
SELECT id, name FROM users;

id|name    |
--+--------+
 1|Геннадий|
 
/* Создайте представление, которое выводит название name товарной позиции
 из таблицы products и соответствующее название каталога name из таблицы catalogs. */
 
CREATE VIEW cat_name AS
    SELECT name,
    (SELECT name FROM catalogs WHERE id = products.catalog_id) AS catalog_name
FROM products;
SELECT * FROM cat_name;

name                   |catalog_name     |
-----------------------+-----------------+
Intel Core i3-8100     |Процессоры       |
Intel Core i5-7400     |Процессоры       |
AMD FX-8320E           |Процессоры       |
AMD FX-8320            |Процессоры       |
ASUS ROG MAXIMUS X HERO|Материнские платы|
Gigabyte H310M S2H     |Материнские платы|
MSI B250M GAMING PRO   |Материнские платы|

/* Создайте хранимую функцию hello(), которая будет возвращать приветствие,
 в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DROP FUNCTION IF EXISTS hello;

DELIMITER $$

CREATE FUNCTION hello() RETURNS TEXT
    BEGIN
        DECLARE return_message text;
        if hour(now()) between 6 and 12 then 
            set return_message = 'Доброе утро';
        elseif hour(now()) between 12 and 18 then 
            set return_message = 'Добрый день';
        elseif hour(noow()) between 18 and 00 then 
            set return_message = 'Добрый вечер';
        else set return_message = 'Доброй ночи';
        end if;
    RETURN return_message;
    END $$
    
DELIMITER ;    
SELECT hello();

/* В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
 Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
 При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DELIMITER $$

CREATE TRIGGER check_products BEFORE INSERT ON products
FOR EACH ROW 
    BEGIN
        IF ISNULL(NEW.name) AND ISNULL(NEW.description) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Columns "name" and "description" must not be Null';
        END IF;
    END$$

DELIMITER ;
 
INSERT INTO products(name, description) VALUES (NULL, NULL);

-- SQL Error [1644] [45000]: Error: Columns "name" and "description" must not be Null
