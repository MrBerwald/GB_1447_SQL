/*1.В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции:
*/

CREATE DATABASE sample;


#exit
#mysqldump shop > sample.sql
#mysql sample < sample.sql
#mysql
#mysql -Nse 'SHOW TABLES' sample | WHILE READ TABLE; do mysql -e "TRUNCATE TABLE $table" sample; done

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;


/*2.Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs:
*/

USE shop;
CREATE VIEW product_names (name, product_type) AS
  SELECT
    p.name,
    c.name
  FROM products AS p JOIN catalogs as c
  ON c.id = p.catalog_id;
