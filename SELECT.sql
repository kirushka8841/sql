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

--Количество исполнителей в каждом жанре.
SELECT name, COUNT(genre_id) FROM genre g
LEFT JOIN genreartist ga ON g.id = ga.genre_id 
GROUP BY g.name;

--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT name, COUNT(track_id) FROM album
LEFT JOIN trackalbum ON album.id = trackalbum.album_id
WHERE year_ BETWEEN 2019 AND 2020
GROUP BY album.name;

--Средняя продолжительность треков по каждому альбому.
SELECT name, AVG(duration) FROM track
LEFT JOIN trackalbum ON track.id = trackalbum.album_id
GROUP BY track.name;

--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT a.name FROM artist a
FULL JOIN artistalbum aa ON a.id = aa.artist_id
FULL JOIN album ON aa.album_id = album.id 
WHERE year_ NOT IN ('2020')
GROUP BY a.name;

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT a.name FROM album a
FULL JOIN artistalbum ON a.id = artistalbum.album_id 
FULL JOIN artist ON artistalbum.artist_id = artist.id 
WHERE artist.name LIKE '%104%';

--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT album.name, COUNT(genre_id) FROM album
FULL JOIN artistalbum ON album.id = artistalbum.album_id 
FULL JOIN artist ON artistalbum.artist_id = artist.id 
FULL JOIN genreartist ON artistalbum.artist_id = genreartist.artist_id 
GROUP BY album.name
HAVING COUNT(genreartist.genre_id) > 1
ORDER BY album.name;

--Наименования треков, которые не входят в сборники.
SELECT name FROM track
FULL JOIN trackcollection ON track.id = trackcollection.track_id 
WHERE trackcollection.track_id IS NULL;

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT name, MIN(duration) FROM artist
FULL JOIN artistalbum ON artist.id = artistalbum.artist_id 
FULL JOIN track ON artistalbum.album_id = track.album_id
WHERE duration <= (SELECT MIN(duration) FROM track)
GROUP BY artist.name;

--Названия альбомов, содержащих наименьшее количество треков.
SELECT album.name, COUNT(track_id) FROM album
FULL JOIN trackalbum ON album.id = trackalbum.album_id
GROUP BY album.name 
HAVING COUNT(track_id) in (
    	SELECT COUNT(track_id) FROM album
    	FULL JOIN trackalbum ON album.id = trackalbum.album_id
        GROUP BY album.name
        ORDER BY COUNT(track_id)
        LIMIT 1);


