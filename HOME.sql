

-- 2.Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.


USE vk;
 
SELECT
    from_user_id
    , COUNT(*) as send 
FROM messages 
WHERE to_user_id=1
GROUP BY from_user_id
ORDER BY send DESC;

-- Не до конца понял эту тему, по этому написал как смог, буду переспатривать лекции, а то потерял нить логичискую. 


-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.


SELECT COUNT(*) as 'Likes' FROM profiles WHERE (YEAR(NOW())-YEAR(birthday)) < 10;


-- 4.Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT  gender
        , COUNT(*) AS total
        , SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male
        , SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female
FROM    users;

-- Логично предтавить что больше поставили лайкой Famele;