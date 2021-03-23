--Наиболее полезный игрок за каждый матч
with rating as(select match_id, account_id, kills, assists,
row_number() over
    (partition by match_id order by (kills+assists) desc) as place_in_match
from  players)

select match_id,account_id,kills+ assists as kills_and_assists,  row_number() over(order by (kills+assists) desc) as absolute_place
from rating where place_in_match=1;

--Самый неудачный персонаж в игре
select hero_id, min(kills+assists-deaths) as failure, row_number() over (order by min(kills+assists-deaths)) as place from players
group by hero_id
order by failure;

--При победе какой стороны больше хороших отзывов
select radiant_win, sum(positive_votes) as total_positive, sum(negative_votes) as total_negative,
       (sum(positive_votes)*100/(sum(positive_votes)+sum(negative_votes))) as positive_percent,
(sum(negative_votes)*100/(sum(positive_votes)+sum(negative_votes))) as negative_percent
       from match
group by radiant_win;

