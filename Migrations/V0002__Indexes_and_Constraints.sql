ALTER TABLE [User]
ADD CONSTRAINT DF_User_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE [User]
ADD CONSTRAINT DF_User_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE Genre
ADD CONSTRAINT DF_Genre_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE Genre
ADD CONSTRAINT DF_Genre_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;
ALTER TABLE Genre
ADD CONSTRAINT UQ_Genre_GenreName UNIQUE ([GenreName]);

ALTER TABLE Artist
ADD CONSTRAINT DF_Artist_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE Artist
ADD CONSTRAINT DF_Artist_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE Album
ADD CONSTRAINT DF_Album_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE Album
ADD CONSTRAINT DF_Album_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE Song
ADD CONSTRAINT DF_Song_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE Song
ADD CONSTRAINT DF_Song_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE ArtistAlbum
ADD CONSTRAINT DF_ArtistAlbum_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE ArtistAlbum
ADD CONSTRAINT DF_ArtistAlbum_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE Playlist
ADD CONSTRAINT UQ_Playlist_Title_UserId UNIQUE (Title, UserId);
ALTER TABLE Playlist
ADD CONSTRAINT DF_Playlist_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE Playlist
ADD CONSTRAINT DF_Playlist_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE UserPlaylist
ADD CONSTRAINT DF_UserPlaylist_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE UserPlaylist
ADD CONSTRAINT DF_UserPlaylist_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE AlbumSong
ADD CONSTRAINT DF_AlbumSong_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE AlbumSong
ADD CONSTRAINT DF_AlbumSong_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE SongGenre
ADD CONSTRAINT DF_SongGenre_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE SongGenre
ADD CONSTRAINT DF_SongGenre_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;

ALTER TABLE AlbumGenre
ADD CONSTRAINT DF_AlbumGenre_CreatedOn DEFAULT (getutcdate()) FOR CreatedOn;
ALTER TABLE AlbumGenre
ADD CONSTRAINT DF_AlbumGenre_CreatedBy DEFAULT (suser_name()) FOR CreatedBy;
