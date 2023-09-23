CREATE TABLE [User] (
    UserId integer IDENTITY (1, 1) NOT NULL,
    UserName nvarchar(100) NOT NULL,
    Email varchar(100) NOT NULL,
    SubscriptionType varchar(20) NOT NULL,
    RegistrationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    UpdatedOn datetime2(7) NULL,
    UpdatedBy nvarchar(100) NULL,
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED (UserId ASC)
);

CREATE TABLE Genre (
    GenreID integer IDENTITY (1, 1) NOT NULL,
    GenreName varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Genre PRIMARY KEY CLUSTERED (GenreID ASC)
);

CREATE TABLE Artist (
    ArtistId integer IDENTITY (1, 1) NOT NULL,
    ArtistName nvarchar(100) NOT NULL,
    Biography nvarchar(MAX) NOT NULL,
    GenreId varchar(20) NOT NULL,
    FormationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY CLUSTERED (ArtistId ASC)
);

CREATE TABLE Album (
    AlbumId integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    TotalDuration time NOT NULL,
    GenreId integer NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY CLUSTERED (AlbumId ASC)
);

CREATE TABLE Song (
    SongId integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    Duration time NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Song PRIMARY KEY CLUSTERED (SongId ASC)
);

CREATE TABLE ArtistAlbum (
    ArtistAlbumId integer IDENTITY (1, 1) NOT NULL,
    ArtistId integer NOT NULL,
    AlbumId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_ArtistAlbum PRIMARY KEY CLUSTERED (ArtistAlbumId ASC),
    CONSTRAINT FK_ArtistAlbum FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId)
);

CREATE TABLE Playlist (
    PlaylistId integer IDENTITY (1, 1) NOT NULL,
    Title varchar(100) NOT NULL,
    [Description] varchar(200),
    UserID int NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Playlist PRIMARY KEY CLUSTERED (PlaylistId ASC),
    CONSTRAINT FK_Playlist_User FOREIGN KEY (UserID) REFERENCES [User] (UserID)
);

CREATE TABLE UserPlaylist (
    UserPlaylistID integer IDENTITY (1, 1) NOT NULL,
    UserID int NOT NULL,
    PlaylistID int NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_UserPlaylist PRIMARY KEY CLUSTERED (UserPlaylistID ASC),
    CONSTRAINT FK_UserPlaylist_User FOREIGN KEY (UserID) REFERENCES [User] (UserID),
    CONSTRAINT FK_UserPlaylist_Playlist FOREIGN KEY (PlaylistID) REFERENCES Playlist (PlaylistID)
);

CREATE TABLE AlbumSong (
    AlbumID int NOT NULL,
    SongID int NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_AlbumSong PRIMARY KEY CLUSTERED (AlbumID, SongID),
    CONSTRAINT FK_AlbumSong_Album FOREIGN KEY (AlbumID) REFERENCES Album (AlbumID),
    CONSTRAINT FK_AlbumSong_Song FOREIGN KEY (SongID) REFERENCES Song (SongID)
);

CREATE TABLE SongGenre (
    SongID int NOT NULL,
    GenreID int NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_SongGenre PRIMARY KEY CLUSTERED (SongID, GenreID),
    CONSTRAINT FK_SongGenre_Song FOREIGN KEY (SongID) REFERENCES Song (SongID),
    CONSTRAINT FK_SongGenre_Genre FOREIGN KEY (GenreID) REFERENCES Genre (GenreID)
);

CREATE TABLE AlbumGenre (
    AlbumID int NOT NULL,
    GenreID int NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_AlbumGenre PRIMARY KEY CLUSTERED (AlbumID, GenreID),
    CONSTRAINT FK_AlbumGenre_Album FOREIGN KEY (AlbumID) REFERENCES Album (AlbumID),
    CONSTRAINT FK_AlbumGenre_Genre FOREIGN KEY (GenreID) REFERENCES Genre (GenreID)
);
