SELECT name, year_ FROM album
WHERE year_ = 2018;

SELECT name, duration FROM track
order by duration desc
limit 1;

select name, duration from track
where duration >= 3.30;

SELECT name, year_ FROM collection c 
WHERE year_ between  2018 and 2020;

SELECT name FROM artist
WHERE name not like '%% %%';

SELECT name FROM track
WHERE name like '%%My%%';


