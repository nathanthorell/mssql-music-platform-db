CREATE TABLE Subscription (
    Code varchar(10) NOT NULL,
    [Description] varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Subscription PRIMARY KEY CLUSTERED (Code ASC)
);

CREATE TABLE [User] (
    UserId integer IDENTITY (1, 1) NOT NULL,
    UserName nvarchar(100) NOT NULL,
    Email varchar(100) NOT NULL,
    SubscriptionCode varchar(10) NOT NULL,
    RegistrationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    UpdatedOn datetime2(7) NULL,
    UpdatedBy nvarchar(100) NULL,
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED (UserId ASC),
    CONSTRAINT FK_User_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
);

CREATE TABLE [Payment] (
    PaymentId integer IDENTITY (1, 1) NOT NULL,
    UserId integer NOT NULL,
    SubscriptionCode varchar(10) NOT NULL,
    Amount decimal(6, 2) NOT NULL,
    PaymentState varchar(20) NOT NULL,
    PostedDate datetime2(7) NOT NULL,
    SettledDate datetime2(7) NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    UpdatedOn datetime2(7) NULL,
    UpdatedBy nvarchar(100) NULL,
    CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED (UserId ASC),
    CONSTRAINT FK_Payment_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (UserId),
    CONSTRAINT FK_Payment_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
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
    GenreId integer NOT NULL,
    FormationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY CLUSTERED (ArtistId ASC),
    CONSTRAINT FK_Artist_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
);

CREATE TABLE Album (
    AlbumId integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    TotalDuration time NOT NULL,
    GenreId integer NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY CLUSTERED (AlbumId ASC),
    CONSTRAINT FK_Album_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
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
    CONSTRAINT FK_ArtistAlbum_ArtistId FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId)
);

CREATE TABLE Playlist (
    PlaylistId integer IDENTITY (1, 1) NOT NULL,
    Title varchar(100) NOT NULL,
    [Description] varchar(200),
    UserID integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_Playlist PRIMARY KEY CLUSTERED (PlaylistId ASC),
    CONSTRAINT FK_Playlist_User_UserId FOREIGN KEY (UserID) REFERENCES [User] (UserID)
);

CREATE TABLE UserPlaylist (
    UserPlaylistID integer IDENTITY (1, 1) NOT NULL,
    UserID integer NOT NULL,
    PlaylistID integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_UserPlaylist PRIMARY KEY CLUSTERED (UserPlaylistID ASC),
    CONSTRAINT FK_UserPlaylist_User_UserId FOREIGN KEY (UserID) REFERENCES [User] (UserID),
    CONSTRAINT FK_UserPlaylist_Playlist_PlaylistId FOREIGN KEY (PlaylistID) REFERENCES Playlist (PlaylistID)
);

CREATE TABLE AlbumSong (
    AlbumID integer NOT NULL,
    SongID integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_AlbumSong PRIMARY KEY CLUSTERED (AlbumID, SongID),
    CONSTRAINT FK_AlbumSong_Album_AlbumId FOREIGN KEY (AlbumID) REFERENCES Album (AlbumID),
    CONSTRAINT FK_AlbumSong_Song_SongId FOREIGN KEY (SongID) REFERENCES Song (SongID)
);

CREATE TABLE SongGenre (
    SongID integer NOT NULL,
    GenreID integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_SongGenre PRIMARY KEY CLUSTERED (SongID, GenreID),
    CONSTRAINT FK_SongGenre_Song_SongId FOREIGN KEY (SongID) REFERENCES Song (SongID),
    CONSTRAINT FK_SongGenre_Genre_GenreId FOREIGN KEY (GenreID) REFERENCES Genre (GenreID)
);

CREATE TABLE AlbumGenre (
    AlbumID integer NOT NULL,
    GenreID integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2(7) NOT NULL,
    CONSTRAINT PK_AlbumGenre PRIMARY KEY CLUSTERED (AlbumID, GenreID),
    CONSTRAINT FK_AlbumGenre_Album_AlbumId FOREIGN KEY (AlbumID) REFERENCES Album (AlbumID),
    CONSTRAINT FK_AlbumGenre_Genre_GenreId FOREIGN KEY (GenreID) REFERENCES Genre (GenreID)
);
