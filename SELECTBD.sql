--Количество исполнителей в каждом жанре.
SELECT g.genre_name, count(ga.artists_id) FROM genres g
   JOIN genres_artists ga ON g.id = ga.genres_id
   GROUP BY g.genre_name;
  
--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT count(t.id) FROM albums al
   JOIN tracks t ON al.id = t.album_id
   WHERE al.album_date BETWEEN 2019 and 2020;
   
--Средняя продолжительность треков по каждому альбому.
SELECT al.album_name, AVG(t.track_duration) FROM albums al
	JOIN tracks t ON al.id = t.album_id
	GROUP BY al.album_name;

--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT ar.artist_name FROM artists ar
    WHERE ar.artist_name NOT IN (
    SELECT DISTINCT ar.artist_name FROM artists ar
    JOIN albums_artists aa ON ar.id = aa.artists_id
    JOIN albums a ON a.id = aa.albums_id
    WHERE a.album_date = 2020); 
  
--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.collection_name FROM collections c
   JOIN tracks_collections tc ON c.id = tc.collection_id
   JOIN tracks t ON t.id = tc.track_id
   JOIN albums a ON a.id = t.album_id
   JOIN albums_artists aa ON a.id = aa.albums_id
   JOIN artists ar ON ar.id = aa.artists_id 
   WHERE ar.artist_name LIKE '%104%';
  
--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.album_name FROM albums a
	JOIN albums_artists aa ON a.id = aa.albums_id
	JOIN artists ar ON ar.id = aa.artists_id
	JOIN genres_artists ga ON ga.artists_id = ar.id
	JOIN genres g ON g.id = ga.genres_id
	GROUP BY ar.artist_name, a.album_name
    HAVING count(ga.genres_id) > 1;
   
--Наименования треков, которые не входят в сборники.
SELECT t.track_name FROM tracks t
	LEFT JOIN  tracks_collections tc ON t.id = tc.track_id
	WHERE tc.track_id IS null;

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT ar.artist_name FROM artists ar
	JOIN albums_artists aa ON ar.id = aa.artists_id 
	JOIN albums a ON a.id = aa.albums_id
	JOIN tracks t ON t.album_id = a.id
	WHERE track_duration = (SELECT min(track_duration) FROM tracks);

--Названия альбомов, содержащих наименьшее количество треков.
SELECT al.album_name , count(t.id) FROM albums al
    JOIN tracks t ON al.id = t.album_id
    GROUP BY al.album_name 
    HAVING count(t.id) in (
    	SELECT count(t.id) FROM albums al
    	JOIN tracks t ON al.id = t.album_id
        GROUP BY al.album_name
        ORDER BY count(t.id)
        LIMIT 1);