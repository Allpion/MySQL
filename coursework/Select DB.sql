-- Выбираем топ 10 книг с высоким рейтингом

SELECT b.title AS book, a.name AS author, g.name AS genre, count(rb.id) AS reting 
FROM books b 
    JOIN authors a ON (b.author_id = a.id)
    JOIN rating_book rb ON (rb.book_id = b.id)
    JOIN genre g ON (g.id = b.genre_id)
GROUP BY title 
ORDER BY reting DESC LIMIT 10;

book                                                                                |author                 |genre       |reting|
------------------------------------------------------------------------------------+-----------------------+------------+------+
Fugiat pariatur debitis tenetur maxime veritatis quis.                              |Ara Funk               |Encyclopedia|    73|
Et blanditiis ipsam ut.                                                             |Scarlett Quigley       |Mystery     |    70|
Iure reprehenderit delectus ullam recusandae dolores ducimus asperiores repellendus.|Mrs. Joelle Hartmann MD|Thriller    |    69|
Quibusdam at tempora soluta est consectetur.                                        |Dakota Aufderhar       |Thriller    |    67|
Aut iste dolores debitis voluptatem voluptatum.                                     |Jaclyn Bergnaum        |Art         |    66|
Unde voluptatem placeat consectetur qui suscipit voluptas optio illo.               |Mrs. Maci Waelchi I    |Mystery     |    65|
Optio est distinctio aliquid tenetur et.                                            |Mrs. Joelle Hartmann MD|Encyclopedia|    65|
Voluptatibus molestias quibusdam molestiae.                                         |Nayeli Howell          |Cookbook    |    64|
Corporis tempora sed eum rem aut assumenda.                                         |Aurelio Gottlieb V     |Thriller    |    64|
Est dolorem voluptatem minima labore.                                               |Dr. Claud Bauch        |Thriller    |    63|

-- Книги которые имеют больше всего прочтений

SELECT COUNT(rb.books_id) AS cnt, b.title, g.name genre, a.name author 
FROM reading_books rb 
    JOIN books b ON (b.id = rb.books_id)
    JOIN genre g ON (g.id = b.genre_id)
    JOIN authors a ON (a.id = b.author_id)
GROUP BY rb.books_id 
ORDER BY cnt DESC LIMIT 10;

cnt|title                                                              |genre       |author             |
---+-------------------------------------------------------------------+------------+-------------------+
 19|Veniam expedita dolores nihil.                                     |Science     |Bradly Rowe Jr.    |
 18|Quo maxime quia amet eos repellendus unde ratione.                 |Thriller    |Donnell Pagac      |
 17|Voluptatem in nobis architecto tempore molestias et reiciendis qui.|Science     |Beth Huel          |
 17|Error quibusdam harum cumque totam.                                |Mystery     |Dr. Dexter Kovacek |
 17|Vel ex qui et.                                                     |Horror      |Carolyn Willms     |
 17|Corporis officiis eos porro et quasi iusto aut et.                 |Philosophy  |Mr. Sylvan Nikolaus|
 17|Dolore voluptas quia nesciunt est modi vel.                        |Cookbook    |Reggie Schaden     |
 17|Ratione sed illo similique et in.                                  |Encyclopedia|Bradly Rowe Jr.    |
 16|Aut repellendus dolor eos ut facilis quas sint velit.              |Encyclopedia|Astrid Keefe       |
 16|Ut mollitia quos et quos.                                          |Thriller    |Samara Kohler V    |
 
-- Самые зачитаные пользователи

SELECT COUNT(user_id) AS cnt, u.firstname, u.lastname 
FROM reading_books rb 
    JOIN users u ON (u.id = rb.user_id)
GROUP BY user_id 
ORDER BY cnt DESC LIMIT 10;

cnt|firstname|lastname  |
---+---------+----------+
 19|Joyce    |Lynch     |
 19|Graciela |Braun     |
 18|Elyssa   |McCullough|
 18|Ora      |Turcotte  |
 16|Gerry    |Marks     |
 16|Gordon   |Stanton   |
 16|Angus    |Stehr     |
 16|Minnie   |Ullrich   |
 16|Sidney   |Ryan      |
 16|Jadon    |Vandervort|
 
-- Имя фамилия и e mail пяти пользователей с самым большим количеством прочитанных книг.

SELECT firstname, lastname, email FROM users u 
WHERE u.id IN (
        SELECT user_id FROM (
            SELECT COUNT(user_id) AS cnt, user_id
                FROM reading_books rb 
                GROUP BY user_id 
                ORDER BY cnt DESC LIMIT 5
            ) AS us
);

firstname|lastname  |email                   |
---------+----------+------------------------+
Joyce    |Lynch     |obalistreri@example.com |
Graciela |Braun     |shanny.lakin@example.org|
Ora      |Turcotte  |alden56@example.org     |
Elyssa   |McCullough|sblock@example.org      |
Minnie   |Ullrich   |ova67@example.net       |

