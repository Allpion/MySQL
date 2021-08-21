-- Рекоммендации для пользователей исходя из их предпочтений

DROP PROCEDURE IF EXISTS books_offers;

DELIMITER //

CREATE PROCEDURE books_offers(IN for_user_id INT)
    BEGIN
        SELECT b.title, a.name author, g.name genre
        FROM books b   
            JOIN authors a ON a.id = b.author_id 
            JOIN genre g ON g.id = b.genre_id 
        WHERE b.author_id in 
            (select author_id from books where b.id in 
            (select book_id from rating_book where user_id = for_user_id))
        OR  b.author_id in 
            (select author_id from books where b.id in 
            (select books_id from reading_books where user_id = for_user_id))
    ORDER BY RAND()
    LIMIT 10;
    END//
    
DELIMITER ;

CALL books_offers(1);

title                                                     |author               |genre       |
----------------------------------------------------------+---------------------+------------+
Et blanditiis ipsam ut.                                   |Scarlett Quigley     |Mystery     |
Quia nihil quod sunt nemo reiciendis veniam sequi.        |Benny Kautzer        |Thriller    |
Nihil sed quam magnam aut sed sit.                        |Titus Schaden PhD    |Horror      |
Eos ut facilis voluptates in et consequatur.              |Carolyn Willms       |Thriller    |
Veniam at explicabo voluptatum fuga.                      |Alejandrin Hegmann   |Mystery     |
Ad dolore necessitatibus nulla officia quasi doloribus ad.|Dr. Claud Bauch      |Encyclopedia|
Possimus dolorem doloribus cumque ea.                     |Scarlett Quigley     |Horror      |
Aut iste dolores debitis voluptatem voluptatum.           |Jaclyn Bergnaum      |Art         |
Omnis repudiandae dolor ut autem quia.                    |Samara Kohler V      |Mystery     |
Corporis molestias voluptatem reiciendis.                 |Ms. Verda Lebsack III|Philosophy  |



-- Выбор топ книг по жанрам

DROP PROCEDURE IF EXISTS top_genre;

DELIMITER //

CREATE PROCEDURE top_genre (IN genre_name VARCHAR(50), IN count_books INT)

    BEGIN
        SELECT b.title 
        FROM books b
            JOIN authors a ON a.id = b.author_id
            JOIN genre g ON (g.id = b.genre_id AND g.name = genre_name)
            JOIN rating_book rb ON rb.book_id = b.id 
        GROUP BY b.id 
        ORDER BY rb.book_id DESC
        LIMIT count_books;
    END//
    
DELIMITER ;

CALL top_genre('Horror', 5);

title                                                 |
------------------------------------------------------+
Quam aut accusantium dignissimos est aliquid.         |
Nihil sed quam magnam aut sed sit.                    |
Possimus dolorem doloribus cumque ea.                 |
Et voluptatem sequi eum sequi id ut libero cupiditate.|
Vel ex qui et.                                        |

-- Функция для подчета колличества прочитанных книг конкретным пользователем

DROP FUNCTION IF EXISTS count_read;

DELIMITER //

CREATE FUNCTION count_read(check_user INT)
RETURNS INT DETERMINISTIC
    BEGIN
       RETURN (SELECT SUM(`count`) FROM reading_books WHERE user_id = check_user);
    END//
    
DELIMITER ;

SELECT count_read(5);

count_read(5)|
-------------+
           29|
