use vk;
  -- 1.Определим кто больше поставил лайков (всего)- мужчины или женщины:

SELECT u.gender, COUNT(l.user_id) AS total
  FROM users AS u
    JOIN likes AS l
  ON u.id = l.user_id
  GROUP BY u.gender
  ORDER BY total DESC LIMIT 1;
  
  
-- 2.Подсчитать количество лайков, которые получили десять самых молодых пользователей:
  SELECT SUM(total_likes) total FROM
  (SELECT COUNT(l.target_id) AS total_likes
    FROM profiles AS p
      LEFT JOIN likes AS l
        ON p.user_id = l.target_id AND l.target_type_id = 2
    GROUP BY p.user_id
    ORDER BY p.birthday 
    DESC LIMIT 10) as user_likes;