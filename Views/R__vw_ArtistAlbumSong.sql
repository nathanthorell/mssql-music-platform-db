CREATE OR ALTER VIEW vw_ArtistAlbumSong
AS
SELECT
    Artist.ArtistName,
    Album.Title AS AlbumTitle,
    Song.Title AS SongTitle,
    Song.Duration AS SongDuration,
    Album.ReleaseDate AS AlbumReleaseDate,
    (SELECT GenreName FROM Genre WHERE GenreId = Album.GenreId) AS AlbumGenre
FROM AlbumSong
JOIN Album ON Album.AlbumId = AlbumSong.AlbumId
JOIN Song ON Song.SongId = AlbumSong.SongId
JOIN ArtistAlbum ON Album.AlbumId = ArtistAlbum.AlbumId
JOIN Artist ON Artist.ArtistId = ArtistAlbum.ArtistId;
