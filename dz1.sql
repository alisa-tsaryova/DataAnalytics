--1
SELECT count(match_id) FROM match
WHERE first_blood_time BETWEEN 60 AND 180;

--2
SELECT DISTINCT p.account_id FROM players p
JOIN match m ON p.match_id = m.match_id
WHERE m.radiant_win = 'True'
    AND m.positive_votes > m.negative_votes
    AND p.account_id <> 0
ORDER BY p.account_id;

--3
SELECT p.account_id, avg(m.duration) FROM players p
JOIN match m ON p.match_id = m.match_id
GROUP BY p.account_id
ORDER BY p.account_id;

--4
SELECT sum(p.gold_spent), count(DISTINCT p.hero_id),
       avg(m.duration) FROM players p
JOIN match m ON p.match_id = m.match_id
WHERE p.account_id = 0;

--5
SELECT hn.localized_name,
       count(m.match_id),
       avg(p.kills) AS avg_kills,
       min(p.deaths) AS min_deaths,
       max(p.gold_spent) AS max_gold_spent,
       sum(m.positive_votes) AS sum_positive,
       sum(m.negative_votes) AS sum_negative
FROM players p
JOIN hero_names hn ON p.hero_id = hn.hero_id
JOIN match m ON m.match_id = p.match_id
GROUP BY hn.localized_name
ORDER BY hn.localized_name ASC;

--6
SELECT DISTINCT match_id FROM purchase_log
WHERE(item_id = 42 AND time > 100)
ORDER BY match_id;

--7
SELECT * FROM match m FULL OUTER JOIN purchase_log pl
ON m.match_id = pl.match_id
LIMIT 20;
