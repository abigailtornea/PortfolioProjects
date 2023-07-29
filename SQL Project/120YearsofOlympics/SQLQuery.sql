SELECT * from athlete_events

SELECT * from noc_regions


-- How many olympics games have been held?
Select COUNT(DISTINCT Games) AS Olympic_Games
from athlete_events

-- List down all Olympics games held so far.
SELECT Games, City
FROM athlete_events
GROUP BY Games, City
ORDER BY Games asc

-- Mention the total no of nations who participated in each olympics game?

with all_countries as
        (select games, nr.NOC
        from athlete_events
        join noc_regions nr ON nr.NOC = athlete_events.NOC
        group by games, nr.NOC)
    select games, count(1) as total_countries
    from all_countries
    group by games
    order by games;

-- Which year saw the highest and lowest no of countries participating in olympics?

      with all_countries as
              (select games, nr.region
              from athlete_events oh
              join noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;


-- Identify the sport which was played in all summer olympics.

  with t1 as
          	(select count(distinct games) as total_games
          	from athlete_events where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from athlete_events where season = 'Summer'),
          t3 as
          	(select sport, count(1) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;


-- Which Sports were just played only once in the olympics?

      with t1 as
          	(select distinct games, sport
          	from athlete_events),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;

-- Fetch the total no of sports played in each olympic games.

      with t1 as
      	(select distinct games, sport
      	from athlete_events),
        t2 as
      	(select games, count(1) as no_of_sports
      	from t1
      	group by games)
      select * from t2
      order by no_of_sports desc;

-- Fetch oldest athletes to win a gold medal.

    with temp as
            (select name,sex,cast(case when age = 'NA' then '0' else age end as int) as age
              ,team,games,city,sport, event, medal
            from athlete_events),
        ranking as
            (select *, rank() over(order by age desc) as rnk
            from temp
            where medal='Gold')
    select *
    from ranking
    where rnk = 1;

-- Fetch the top 5 athletes who have won the most gold medals.

    with t1 as
            (select name, team, count(1) as total_gold_medals
            from athlete_events
            where medal = 'Gold'
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_gold_medals desc) as rnk
            from t1)
    select name, team, total_gold_medals
    from t2
    where rnk <= 5;


-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
    with t1 as
            (select name, team, count(1) as total_medals
            from athlete_events
            where medal in ('Gold', 'Silver', 'Bronze')
            group by name, team
            ),
        t2 as
            (select *, dense_rank() over (order by total_medals desc) as rnk
            from t1)
    select name, team, total_medals
    from t2
    where rnk <= 5;

-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

    with t1 as
            (select nr.region, count(1) as total_medals
            from athlete_events oh
            join noc_regions nr on nr.noc = oh.noc
            where medal <> 'NA'
            group by nr.region
            ),
        t2 as
            (select *, dense_rank() over(order by total_medals desc) as rnk
            from t1)
    select *
    from t2
    where rnk <= 5;