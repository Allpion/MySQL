/* Создайте таблицу logs типа Archive.
 Пусть при каждом создании записи в таблицах users, catalogs и products
 в таблицу logs помещается время и дата создания записи, название таблицы,
 идентификатор первичного ключа и содержимое поля name. */

DROP TABLE IF EXISTS logs;

CREATE TABLE logs(
    table_id BIGINT NOT NULL,
    name VARCHAR(20) NOT NULL,
    table_name VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL
) ENGINE = Archive;

DELIMITER &&

CREATE TRIGGER check_users AFTER INSERT ON users
FOR EACH ROW
    BEGIN
        INSERT INTO logs SET
            table_id = NEW.id,
            name = NEW.name,
            table_name = 'users',
            created_at = NOW(); 
    END&&
    
CREATE TRIGGER check_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
    BEGIN
        INSERT INTO logs SET
            table_id = NEW.id,
            name = NEW.name,
            table_name = 'catalogs',
            created_at = NOW(); 
    END&&    

CREATE TRIGGER check_product AFTER INSERT ON products
FOR EACH ROW
    BEGIN
        INSERT INTO logs SET
            table_id = NEW.id,
            name = NEW.name,
            table_name = 'products',
            created_at = NOW(); 
    END&&   
    
DELIMITER ;

SELECT * FROM logs;

table_id|name         |table_name|created_at         |
--------+-------------+----------+-------------------+
       7|visor        |users     |2021-08-10 18:56:11|
       8|vifsor       |users     |2021-08-10 18:57:42|
       7|Блоки питания|catalogs  |2021-08-10 19:17:32|
      10|intel celeron|products  |2021-08-10 19:22:15|

