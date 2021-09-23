--  example databese VK.com


-- CREATE DATABASE vk;
USE vk;
-- Example
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", -- искуственный ключ
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  birthday DATE NOT NULL COMMENT 'Дата рождения',
  gender CHAR(1) NOT NULL COMMENT 'Пол',
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта", -- 
  phone CHAR(11) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

ALTER TABLE users MODIFY gender ENUM('M', 'F', '?') NOT NULL COMMENT 'Пол';
DESC users;

CREATE TABLE profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",  
  birthday DATE COMMENT "Дата рождения",
  `status` VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили"; 


ALTER TABLE profiles DROP COLUMN photo_id;
ALTER TABLE profiles ADD CONSTRAINT profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id); 
ALTER TABLE profiles ADD COLUMN gerder ENUM('M', 'F', '?') NOT NULL COMMENT 'Пол';
ALTER TABLE profiles MODIFY `status` ENUM('online', 'offline', 'disabled') NOT NULL COMMENT "Текущий статус";



CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя", 
	friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на друга пользователя", 
    request_type_id INT UNSIGNED NOT NULL COMMENT "Тип запроса",
	requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
	confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    PRIMARY KEY (user_id, friend_id)
);
-- Создаём внешние ключи для таблицы друзья с таблицей пользователя 
ALTER TABLE friendship ADD CONSTRAINT friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

ALTER TABLE friendship MODIFY requested_at DATETIME NOT NULL COMMENT "Время отправления приглашения дружить";

-- таблица справочник
CREATE TABLE friendship_request_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Типы запроса на дружбы";


ALTER TABLE friendship ADD CONSTRAINT friendship_request_type_id FOREIGN KEY (request_type_id) REFERENCES friendship_request_types(id);

CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки" , 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";


ALTER TABLE communities_users ADD CONSTRAINT communities_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE communities_users ADD CONSTRAINT communities_user_id  FOREIGN KEY (user_id) REFERENCES users(id);


CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

ALTER TABLE messages ADD CONSTRAINT messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);

CREATE TABLE media (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
filename VARCHAR(255) NOT NULL UNIQUE COMMENT "Путь к файлу",
media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип файла",
-- metadata JSON NOT NULL COMMENT "Метаданные файла",
user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на польщователя",
created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";

ALTER TABLE media DROP COLUMN metadata;

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

ALTER TABLE media ADD CONSTRAINT media_media_types_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);
ALTER TABLE media ADD CONSTRAINT media_user_id FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE posts (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT UNSIGNED NOT NULL,
community_id INT UNSIGNED,
head VARCHAR(255) COMMENT "Заголовок поста",
body TEXT COMMENT "Поле текта",
media_id INT UNSIGNED,
is_public BOOLEAN DEFAULT TRUE,
is_archived BOOLEAN DEFAULT FALSE,
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
);


ALTER TABLE posts ADD CONSTRAINT posts_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT posts_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE posts ADD CONSTRAINT posts_media_id FOREIGN KEY (media_id) REFERENCES media(id);


CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE likes (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT UNSIGNED NOT NULL,
target_id INT UNSIGNED COMMENT "Ссылка на экземпляр лайкаемой сущности",
target_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип сущности",
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE likes ADD CONSTRAINT likes_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE likes ADD CONSTRAINT likes_target_type_id FOREIGN KEY (target_type_id) REFERENCES target_types(id);

SELECT * FROM profiles;