/*1.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи":
*/
DELIMITER //

DROP PROCEDURE IF EXISTS hello//

CREATE PROCEDURE hello()
BEGIN
  CASE 
    WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '12:00:00' THEN
	  SELECT 'Доброе утро';
	WHEN CURRENT_TIME() BETWEEN '12:00:00' AND '18:00:00' THEN
	  SELECT 'Добрый день';
	WHEN CURRENT_TIME() BETWEEN '18:00:00' AND '00:00:00' THEN
	  SELECT 'Добрый вечер';
	ELSE
	  SELECT 'Доброй ночи';
  END CASE;
END //

CALL hello()//

DELIMITER ;


/* 2.В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию:
*/

DELIMITER //

DROP TRIGGER IF EXISTS check_null_insert//

CREATE TRIGGER check_null_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both name and description can not be NULL';
	END IF;
END //

DROP TRIGGER IF EXISTS check_null_update//

CREATE TRIGGER check_null_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both name and description can not be NULL';
	END IF;
END //

DELIMITER ;