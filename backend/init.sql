CREATE DATABASE pet_photo_gallery;

USE pet_photo_gallery;

CREATE TABLE photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    caption TEXT
);
