/*1.Создайте двух пользователей которые имеют доступ к базе данных shop. 
Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop:
*/
CREATE USER 'shop_read'@'%' IDENTIFIED WITH sha256_password BY 'User1@QWE';
GRANT SELECT ON shop.* TO shop_read;

CREATE USER 'shop'@'%' IDENTIFIED WITH sha256_password BY 'User2@QWERTY';
GRANT ALL ON shop.* TO shop;


/* 2.Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. 
Создайте представление username таблицы accounts, предоставляющий доступ к столбцам id и name. 
Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username:
*/

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя пользователя',
  password VARCHAR(255) COMMENT 'Пароль пользователя',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Аккаунты';

INSERT INTO accounts
  (name, password)
VALUES
  ('Alex', 'Alex@QWE'),
  ('Roman', 'Roman@QWERT'),
  ('Vladislav', 'Vladislav@QWERTY');

CREATE VIEW username (id, name) AS SELECT id, name FROM accounts;

CREATE USER 'user_read'@'%' IDENTIFIED WITH sha256_password BY 'Admin@QWERTYAS';
GRANT SELECT ON shop.username TO user_read;
