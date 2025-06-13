DROP TABLE IF EXISTS spotify;
--------------------------------------------------------------------------------------------------------------

---- CREATING TABLE

--------------------------------------------------------------------------------------------------------------
CREATE TABLE spotify (
	  Artist varchar(300),
	  Track varchar(300),
	  Album varchar(300),
	  Album_type varchar(50),
	  Danceability float,
	  Energy float,
	  Loudness float,
	  Speechiness float,
	  Acousticness float,
	  Instrumentalness float,
	  Liveness float,
	  Valence float,
	  Tempo float,
	  Duration_min float,
	  Title varchar(300),
	  Channel varchar(300),
	  Views bigint,
	  Likes bigint,
	  Comments bigint,
	  Licensed boolean,
	  official_video boolean,
	  Stream bigint,
	  EnergyLiveness float,
	  most_playedon varchar(50)

);

--------------------------------------------------------------------------------------------------------------

--ADDING DATA

--------------------------------------------------------------------------------------------------------------
copy spotify(Artist,Track,Album,Album_type,Danceability,Energy,Loudness,Speechiness,Acousticness,Instrumentalness,Liveness,Valence,Tempo,Duration_min,Title,Channel,Views,Likes,Comments ,Licensed,official_video ,Stream ,EnergyLiveness, most_playedon)
	FROM 'C:\dataset\cleaned_dataset.csv'
	DELIMITER ','
	CSV HEADER;

--------------------------------------------------------------------------------------------------------------

--CHECKING IF DATA HAS BEEN IMPORTED OR NOT

--------------------------------------------------------------------------------------------------------------
select *
from spotify

--------------------------------------------------------------------------------------------------------------

--Exploratory Data Analysis

---------------------------------------------------------------------------------------------------------------
--1>NUMBER OF ROWS
SELECT COUNT(*)
FROM spotify;

--2>How many artists?
select count(distinct(artist))
from spotify;

--3>How many album?
select count(distinct(album))
from spotify;

--4>Types of album
select distinct(album_type)
from spotify;

--5>Longest song 
select max(duration_min)
from spotify;

--6>shortest song 
select min(duration_min)
from spotify;

--7>We need to remove the songs of  with zero duration
delete from spotify
where duration_min =0;
select *
from spotify
where duration_min=0;

--8>Types of channel
select distinct(channel)
from spotify;

--9>platforms where most songs are played on
select distinct(most_playedon)
from spotify;


-------------------------------------------------------------------------------------------------------------

--DATA ANALYSIS

--------------------------------------------------------------------------------------------------------------

/*
1>Retrieve the names of all tracks that have more than 1 billion streams.
2>List all albums along with their respective artists.
3>Get the total number of comments for tracks where licensed = TRUE.
4>Find all tracks that belong to the album type single.
5>Count the total number of tracks by each artist.
*/

--1>Retrieve the names of all tracks that have more than 1 billion streams.
select Track
from spotify
where Stream>=1000000000;


--2>List all albums along with their respective artists.
select distinct(Album),
        Artist
from spotify;


--3>Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments_for_true_licence
from spotify 
where licensed=TRUE;


--4>Find all tracks that belong to the album type single.
select *
from spotify 
where Album_type='single';


--5>Count the total number of tracks by each artist.
select artist,
      count(Track)
from spotify
group by artist
order by 2 desc;


-------------------------------------------------------------------------------------------------------------
/*
6>Calculate the average danceability of tracks in each album.
7>Find the top 5 tracks with the highest energy values.
8>List all tracks along with their views and likes where official_video = TRUE.
9>For each album, calculate the total views of all associated tracks.
10>Retrieve the track names that have been streamed on Spotify more than YouTube.
*/
-------------------------------------------------------------------------------------------------------------

--6>Calculate the average danceability of tracks in each album.
select album,
       avg(danceability) as avg_danceability_of_album 
from spotify
group by Album
order by avg_danceability_of_album desc;



--7>Find the top 5 tracks with the highest energy values.
select track,
       avg(Energy) as avg_energy
from spotify
group by 1
order by 2 desc
limit 5;



--8>List all tracks along with their views and likes where official_video = TRUE.
select track,
       sum(views) as track_Views,
	   sum(likes) as track_likes
from spotify
where official_video=TRUE
group by 1
order by 2 desc;




--9>For each album, calculate the total views of all associated tracks.
select album, 
       track, 
	   sum(views) as total_views
from spotify
group by 1,2
order by 3 desc;
	   
	   
	   
--10>Retrieve the track names that have been streamed on Spotify more than YouTube.

select track,
       --most_playedon,
	   sum(case when most_playedon='youtube' then stream end) as streamed_on_youtube,
	   sum(case when most_playedon='spotify' then stream end) as streamed_on_spotify
from spotify
group by 1
      



