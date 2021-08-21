DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

DROP TABLE IF EXISTS books;
CREATE TABLE books (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    title VARCHAR(100),
    premiere DATE NOT NULL,
    author_id INT UNSIGNED NOT NULL, 
    genre_id INT UNSIGNED NOT NULL,
    description_id INT UNSIGNED DEFAULT NULL, 
    img_id INT UNSIGNED NOT NULL,
    added_at DATETIME DEFAULT NOW()
);

CREATE INDEX books_idx ON books (title);

DROP TABLE IF EXISTS authors;
CREATE TABLE authors ( 
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    name VARCHAR(255) NOT NULL,
    biography_id INT UNSIGNED NOT NULL,
    birthday DATE NOT NULL,
    img_id INT UNSIGNED NOT NULL
);

CREATE INDEX authors_idx ON authors(name);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
    password_hash VARCHAR(100) 
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
    user_id INT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
    img_id INT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS images;
CREATE TABLE images ( 
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `size` INT,
    file_name VARCHAR(255)
);

DROP TABLE IF EXISTS descriptions;
CREATE TABLE descriptions(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    description_book TEXT
);

DROP TABLE IF EXISTS biography;
CREATE TABLE biography (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    biography_author TEXT
);

DROP TABLE IF EXISTS rating_book;
CREATE TABLE rating_book(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, 
    user_id INT UNSIGNED NOT NULL,
    book_id INT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS rating_author;
CREATE TABLE rating_author(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    user_id INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS reading_books;
CREATE TABLE reading_books (
    user_id INT UNSIGNED NOT NULL,
    books_id INT UNSIGNED NOT NULL,
    `count` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, books_id)
);

ALTER TABLE books 
    ADD CONSTRAINT fk_books_img 
    FOREIGN KEY (img_id) REFERENCES images(id),

    ADD CONSTRAINT fk_books_author 
        FOREIGN KEY (author_id) REFERENCES authors(id),
    
    ADD CONSTRAINT fk_books_description 
        FOREIGN KEY (description_id) REFERENCES descriptions(id),
    
    ADD CONSTRAINT fk_books_genre 
        FOREIGN KEY (genre_id) REFERENCES genre(id);

ALTER TABLE authors  
    ADD CONSTRAINT  fk_authors_biography
        FOREIGN KEY (biography_id) REFERENCES biography(id),
 
    ADD CONSTRAINT fk_authors_img 
        FOREIGN KEY (img_id) REFERENCES images(id);

ALTER TABLE profiles 
    ADD CONSTRAINT fk_profiles_users 
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
        
    ADD CONSTRAINT fk_profiles_img
        FOREIGN KEY (img_id) REFERENCES images(id);

ALTER TABLE rating_book 
    ADD CONSTRAINT fk_rating_book_user
        FOREIGN KEY (user_id) REFERENCES users(id),
        
    ADD CONSTRAINT fk_rating_book_books
        FOREIGN KEY (book_id) REFERENCES books(id);

ALTER TABLE rating_author 
    ADD CONSTRAINT fk_rating_author_user
        FOREIGN KEY (user_id) REFERENCES users(id),
        
    ADD CONSTRAINT fk_rating_author_authors
        FOREIGN KEY (author_id) REFERENCES authors(id);

ALTER TABLE reading_books
    ADD CONSTRAINT fk_users
        FOREIGN KEY (user_id) REFERENCES users(id),
        
    ADD CONSTRAINT fk_books
        FOREIGN KEY (books_id) REFERENCES books(id);