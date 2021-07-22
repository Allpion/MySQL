CREATE DATABASE lesson;
-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

/* 1.  Пусть в таблице users поля created_at и updated_at оказались незаполненными.
   Заполните их текущими датой и временем. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
);

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  
UPDATE users SET created_at = NOW(), updated_at = NOW();

/* 2.  Таблица users была неудачно спроектирована.
   Записи created_at и updated_at были заданы типом VARCHAR
   и в них долгое время помещались значения в формате 20.10.2017 8:10.
   Необходимо преобразовать поля к типу DATETIME,
   сохранив введённые ранее значения. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(30),
  updated_at VARCHAR(30)
);

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', '02.09.2017 5:10', '20.09.2017 8:10'),
  ('Наталья', '1984-11-12', '22.11.2018 22:11', '20.10.2019 4:13'),
  ('Александр', '1985-05-20', '30.04.2019 18:05', '19.12.2019 15:30'),
  ('Сергей', '1988-02-14', '18.12.2015 12:10', '22.03.2017 8:10'),
  ('Иван', '1998-01-12', '23.02.2021 12:04', '24.10.2021 12:12'),
  ('Мария', '1992-08-29', '20.11.2001 7:10', '22.09.2016 20:10');
  
SELECT * from users 

UPDATE users 
SET created_at = STR_TO_DATE(created_at, "%d.%m.%Y %k:%i"),
	updated_at = STR_TO_DATE(updated_at, "%d.%m.%Y %k:%i")
	
ALTER TABLE users 
MODIFY created_at DATETIME,
MODIFY updated_at DATETIME

DESCRIBE users

/* 3.  В таблице складских запасов storehouses_products в поле value
   могут встречаться самые разные цифры: 0, если товар закончился и выше нуля,
   если на складе имеются запасы. Необходимо отсортировать записи таким образом,
   чтобы они выводились в порядке увеличения значения value.
   Однако нулевые запасы должны выводиться в конце, после всех записей. */

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SELECT value FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 1 ELSE 0 END, value
SELECT value FROM storehouses_products ORDER BY ISNULL(value), value DESC 

/* 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.*/

SELECT name, birthday_at FROM users
WHERE DATE_FORMAT(birthday_at, '%m') = 05 OR DATE_FORMAT(birthday_at, '%m') = 08 

/* 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
   SELECT * FROM catalogs WHERE id IN (5, 1, 2);
   Отсортируйте записи в порядке, заданном в списке IN. */

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT * FROM catalogs WHERE id IN (5, 1, 2);
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2) 

-- Практическое задание теме «Агрегация данных»

-- 1. Подсчитайте средний возраст пользователей в таблице users.

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users

/* 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
  Следует учесть, что необходимы дни недели текущего года, а не года рождения. */


SELECT DAYNAME(date_format(birthday_at, '2021-%m-%d')) AS 'week_day',
	   COUNT(*) AS 'birthdays'  	
FROM users
GROUP BY DAYNAME(date_format(birthday_at, '2021-%m-%d'))

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы

SELECT EXP(SUM(LN(id))) FROM users 

-- т.к в таблице users в столбце id шесть записей с 1 по 6 то поизведение чисел будет 720.