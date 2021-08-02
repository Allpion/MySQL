/* Составьте список пользователей users,
 которые осуществили хотя бы один заказ orders в интернет магазине. */


INSERT INTO orders(user_id) VALUES (1), (4), (5);

SELECT u.name, o.user_id
    FROM users u 
    JOIN orders o 
    ON u.id = o.user_id;

name    |user_id|
--------+-------+
Геннадий|      1|
Сергей  |      4|
Иван    |      5|

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.name, c.name
    FROM products p 
    JOIN catalogs c 
    ON p.catalog_id = c.id 
    
name                   |name             |
-----------------------+-----------------+
Intel Core i3-8100     |Процессоры       |
Intel Core i5-7400     |Процессоры       |
AMD FX-8320E           |Процессоры       |
AMD FX-8320            |Процессоры       |
ASUS ROG MAXIMUS X HERO|Материнские платы|
Gigabyte H310M S2H     |Материнские платы|
MSI B250M GAMING PRO   |Материнские платы|


/* (по желанию) Пусть имеется таблица рейсов flights (id, from, to)
 и таблица городов cities (label, name). Поля from, to и label
 содержат английские названия городов, поле name — русское.
 Выведите список рейсов flights с русскими названиями городов. */

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
    id SERIAL PRIMARY KEY AUTO_INCREMENT,
    `from` VARCHAR(20) NOT NULL,
    `to` VARCHAR(20) NOT NULL 
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
    label VARCHAR(20) NOT NULL,
    name VARCHAR(20) NOT NULL
);

INSERT INTO flights(`from`, `to`)
VALUES  ('Blagoveshchensk',  'Astrakhan'),
        ('Gatchina', 'Yessentuki'),
        ('Krasnoyarsk', 'Izhevsk'),
        ('Lipetsk', 'Novokuznetsk'),
        ('Penza',  'Norilsk');
    
INSERT INTO cities
VALUES  ('Blagoveshchensk', 'Благовещенск'),
        ('Astrakhan', 'Астрахань'),
        ('Gatchina', 'Гатчина'),
        ('Yessentuki', 'Ессентуки'),
        ('Krasnoyarsk', 'Красноярск'),
        ('Izhevsk', 'Ижевск'),
        ('Lipetsk', 'Липецк'),
        ('Novokuznetsk', 'Новокузнецк'),
        ('Penza', 'Пенза'),
        ('Norilsk', 'Норильск');

SELECT f.id, fr.name AS `from`, t.name AS `to` from flights f 
    JOIN cities AS fr ON (fr.label = f.`from`) 
    JOIN cities AS t ON (t.label = f.`to`) 
    
    

































select * from catalogs c 
union 
select id, name from products p 
union
select id, name from users;


select * from catalogs c;

select id, name, catalog_id from products p;

select id, name, catalog_id
from products p 
where catalog_id = 1;

select id, name, catalog_id
from products p 
where catalog_id = (select id from catalogs c where name = 'Процессоры')

select max(price) from products p 

select id, name, catalog_id
from products p 
where price = (select max(price) from products p2);

select id, name, catalog_id
from products p;

select id, name, (select name from catalogs where id = catalog_id) as 'catalog'
from products;

SELECT
  id, name, catalog_id
FROM
  products
WHERE
  catalog_id in (SELECT id FROM catalogs);
  
select id, name, price, catalog_id
from products
where catalog_id = 2 and 
    price < any (select price from products where catalog_id =1);
    
select id, name, price, catalog_id
from products 
order by catalog_id, price 

SELECT
  id, name, price, catalog_id
FROM
  products
WHERE
  catalog_id = 2 AND
  price < SOME (SELECT price FROM products WHERE catalog_id = 1);
  
  SELECT
  id, name, price, catalog_id
FROM
  products
WHERE
  catalog_id = 2 AND
  price > ALL (SELECT price FROM products WHERE catalog_id = 1);
  
select avg(price)
from
(select min(price) as price from products p group by catalog_id) as prod

select p.name, p.price, c.name
from catalogs c 
join products p 
on c.id = p.catalog_id 

select * from catalogs fst join catalogs snd on fst.id = snd.id 

SELECT
  p.name,
  p.price,
  c.name
FROM
  catalogs AS c
LEFT JOIN
  products AS p
ON
  c.id = p.catalog_id;