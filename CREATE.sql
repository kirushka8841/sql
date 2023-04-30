create table if not exists Genre(
	id SERIAL primary key,
	name VARCHAR(40) not NULL
);

create table if not exists Artist(
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT null
);

create table if not exists GenreArtist(
	Genre_id INTEGER references Genre(id),
	Artist_id INTEGER references Artist(id),
	CONSTRAINT PK_GenreArtist PRIMARY KEY (genre_id, artist_id)
);

create table if not exists Album(
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT null,
	year_ INTEGER not null
);

create table if not exists ArtistAlbum(
	Artist_id INTEGER references Artist(id),
	Album_id INTEGER references Album(id),
	CONSTRAINT PK_ArtistAlbum PRIMARY KEY (artist_id, album_id)
);

create table if not exists Track(
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT null,
	duration numeric not null,
	album_id integer references Album(id)
);

create table if not exists Collection(
	id SERIAL PRIMARY KEY,
	name VARCHAR(40) NOT null,
	year_ INTEGER not null
);

create table if not exists TrackCollection(
	Track_id INTEGER references Track(id),
	Collection_id INTEGER references Collection(id),
	CONSTRAINT PK_TrackCollection PRIMARY KEY (track_id, collection_id)
);

