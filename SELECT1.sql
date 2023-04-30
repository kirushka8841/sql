--Количество исполнителей в каждом жанре.
SELECT g.name, count(ga.artist_id) FROM genre g
   FULL JOIN genreartist ga ON g.id = ga.genre_id
   GROUP BY g.name;
  
--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT count(id) FROM track
   FULL JOIN album ON track.album_id = album.id
   WHERE album.year_  BETWEEN 2019 and 2020;
   
--Средняя продолжительность треков по каждому альбому.
SELECT al.name, AVG(duration) FROM album al
	FULL JOIN track t ON al.id = t.album_id
	GROUP BY al.name;

--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT name FROM artist
   WHERE id NOT IN(SELECT artist_id FROM artistalbum
   FULL JOIN album ON album.id = artistalbum.album_id
   WHERE album.year_ = 2020);
  
--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT DISTINCT c.name FROM collection c
   JOIN trackcollection tc ON c.id = tc.collection_id
   JOIN track t ON t.id = tc.track_id
   JOIN album a ON a.id = t.album_id
   JOIN artistalbum aa ON a.id = aa.album_id
   JOIN artist ar ON ar.id = aa.artist_id 
   WHERE ar.name LIKE '%104%';
  
--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT DISTINCT a.name FROM album a
	JOIN artistalbum aa ON a.id = aa.album_id
	JOIN artist ar ON ar.id = aa.artist_id
	JOIN genreartist ga ON ga.artist_id = ar.id
	JOIN genre g ON g.id = ga.genre_id
	GROUP BY ar.name, a.name
    HAVING count(ga.genre_id) > 1;
   
--Наименования треков, которые не входят в сборники.
SELECT t.name FROM track t
	LEFT JOIN  trackcollection tc ON t.id = tc.track_id
	WHERE tc.track_id IS null;

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT ar.name FROM artist ar
	JOIN artistalbum aa ON ar.id = aa.artist_id 
	JOIN album a ON a.id = aa.album_id
	JOIN track t ON t.album_id = a.id
	WHERE t.duration = (SELECT min(t.duration) FROM track);

--Названия альбомов, содержащих наименьшее количество треков.
SELECT al.name, count(t.id) FROM album al
    JOIN track t ON al.id = t.album_id
    GROUP BY al.name 
    HAVING count(t.id) IN (
    	SELECT count(t.id) FROM album al
    	JOIN track t ON al.id = t.album_id
        GROUP BY al.name
        ORDER BY count(t.id)
        LIMIT 1);