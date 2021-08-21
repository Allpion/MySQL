-- Новинки за последний год

DROP VIEW IF EXISTS top_new_year;

CREATE VIEW top_new_year AS
(SELECT b.title, g.name AS genre, a.name AS author, b.premiere 
    FROM books b 
        JOIN genre g ON (g.id = b.genre_id)
        JOIN authors a ON (a.id = b.author_id)
    WHERE TO_DAYS(NOW()) - TO_DAYS(b.premiere) < 365
    GROUP BY b.id 
    ORDER BY b.premiere desc 
);

SELECT * FROM top_new_year;

title                                                          |genre       |author            |premiere  |
---------------------------------------------------------------+------------+------------------+----------+
Beatae ducimus labore excepturi doloribus distinctio sit totam.|Science     |Jaylin Breitenberg|2021-05-22|
Laborum est iure ea non.                                       |Thriller    |Della Becker      |2021-02-05|
Aut iste dolores debitis voluptatem voluptatum.                |Art         |Jaclyn Bergnaum   |2021-01-06|
Possimus dolore atque reiciendis qui.                          |Encyclopedia|Bret Kuhn         |2020-11-06|
Ratione sed illo similique et in.                              |Encyclopedia|Bradly Rowe Jr.   |2020-09-01|

-- Самые популярные авторы

DROP VIEW IF EXISTS popular_author;

CREATE VIEW popular_author AS
(SELECT COUNT(ra.author_id) AS reting, a.name 
    FROM authors a 
        JOIN rating_author ra ON (ra.author_id = a.id)
    GROUP BY a.name 
    ORDER BY reting DESC LIMIT 10
);

SELECT * FROM popular_author; 

reting|name                 |
------+---------------------+
    33|Ibrahim Eichmann     |
    32|Petra Heaney Sr.     |
    32|Andy Kub             |
    31|Dr. Dexter Kovacek   |
    30|Lance Langworth      |
    28|Fannie Keeling       |
    27|Buster Wiza          |
    27|Keshawn Zulauf Sr.   |
    26|Delores Kirlin       |
    26|Bernita Aufderhar DDS|
    



DROP TABLE IF EXISTS user_logs;
-- Создаём таблицу логов для пользователей
CREATE TABLE user_logs(
    user_id INT UNSIGNED NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL
) ENGINE = Archive;

DROP TABLE IF EXISTS backup_user;
-- Таблица для хранения удалённых данных пользователей
CREATE TABLE backup_user(
    user_id INT UNSIGNED NOT NULL,    
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    event_date DATETIME NOT NULL,
    event ENUM ('delete', 'update')
) ENGINE = Archive;

DROP TRIGGER IF EXISTS check_users;
DROP TRIGGER IF EXISTS update_user;
DROP TRIGGER IF EXISTS delete_user;

DELIMITER &&
-- Триггер для записи в таблицу логов данных новых пользователей
CREATE TRIGGER check_users AFTER INSERT ON users
FOR EACH ROW
    BEGIN
        INSERT INTO user_logs SET
            user_id = NEW.id,
            firstname = NEW.firstname,
            lastname = NEW.lastname,
            created_at = NOW(); 
    END&&
-- Триггер для записи в таблицу backup_user данных о пользователе до обновления в таблице users    
CREATE TRIGGER update_user BEFORE UPDATE ON users
FOR EACH ROW
    BEGIN
        INSERT INTO backup_user SET
            user_id = OLD.id,
            firstname = OLD.firstname,
            lastname = OLD.lastname,
            event_date = NOW(),
            event = 'update'; 
    END&&
-- Триггер для записи в таблицу backup_user данных о пользователе до удаления данных из таблицы users
CREATE TRIGGER delete_user BEFORE DELETE ON users
FOR EACH ROW
    BEGIN
        INSERT INTO backup_user SET
            user_id = OLD.id,
            firstname = OLD.firstname,
            lastname = OLD.lastname,
            event_date = NOW(),
            event = 'delete'; 
    END&&

DELIMITER ;


