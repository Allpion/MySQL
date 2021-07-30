/* Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем */

select friend from (
              (select from_user_id friend, count(*) as max_messages 
                      from messages  where to_user_id = 280 group by friend)
               union all
              (select to_user_id friend, count(*) as max_messages
                      from messages  where from_user_id = 280 group by friend)
) best_friend                      
group by friend
order by sum(max_messages) desc limit 1; 

friend|
------+
   201|

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. 

select count(*) from likes 
where user_id in (
    select * from (
        select user_id from profiles order by birthday desc limit 10
        ) user_id 
);

count(*)|
--------+
      83|

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
      
select count(*) cnt from likes 
where user_id in (
    select user_id from profiles where gender = 'f'
)
union 
select count(*) from likes 
where user_id in (
    select user_id from profiles where gender = 'm'
)
order by cnt desc; 

cnt|
---+
487|
369|

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети

SELECT id, SUM(activity) user_activity FROM (
    SELECT * FROM (
                   (SELECT id, 0 activity FROM users WHERE id NOT IN (SELECT user_id FROM likes))
                    UNION
                   (SELECT user_id, COUNT(*) activity FROM likes GROUP BY user_id)    
    ) cnt_likes -- To find the most inactive users in the likes table
    UNION ALL 
    SELECT * FROM (
                   (SELECT id, 0 activity FROM users WHERE id NOT IN (SELECT from_user_id FROM messages))
                    UNION
                   (SELECT from_user_id, COUNT(*) activity FROM messages GROUP BY from_user_id) 
    
    ) cnt_messeges -- To find the most inactive users in the messages table
    UNION ALL 
    SELECT * FROM (
                   (SELECT id, 0 activity FROM users WHERE id NOT IN (SELECT user_id FROM users_communities))
                    UNION
                   (SELECT user_id, COUNT(*) activity FROM users_communities GROUP BY user_id)
    
    ) cnt_communities -- To find the most inactive users in the community table 
) act_colum
GROUP BY id
ORDER BY user_activity
LIMIT 10

id |user_activity|
---+-------------+
401|            0|
404|            0|
403|            0|
402|            0|
314|           17|
322|           17|
319|           17|
400|           17|
315|           17|
321|           17|




