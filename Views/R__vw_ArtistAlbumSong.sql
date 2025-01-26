CREATE OR ALTER VIEW vw_ArtistAlbumSong
AS
SELECT
    Artist.Name AS ArtistName,
    Album.Title AS AlbumTitle,
    Song.Title AS SongTitle,
    Song.Duration AS SongDuration,
    Album.ReleaseDate AS AlbumReleaseDate,
    (SELECT [Name] FROM Genre WHERE Genre.Id = Album.GenreId) AS AlbumGenre
FROM AlbumSong
JOIN Album ON Album.Id = AlbumSong.AlbumId
JOIN Song ON Song.Id = AlbumSong.SongId
JOIN ArtistAlbum ON Album.Id = ArtistAlbum.AlbumId
JOIN Artist ON Artist.Id = ArtistAlbum.ArtistId;
