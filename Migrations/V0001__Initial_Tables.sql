CREATE TABLE Subscription (
    Code varchar(10) NOT NULL,
    [Description] varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Subscription PRIMARY KEY CLUSTERED (Code ASC)
);

CREATE TABLE [User] (
    UserId integer IDENTITY (1, 1) NOT NULL,
    UserName nvarchar(100) NOT NULL,
    Email varchar(100) NOT NULL,
    SubscriptionCode varchar(10) NOT NULL,
    RegistrationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    UpdatedOn datetime2 NULL,
    UpdatedBy nvarchar(100) NULL,
    SysStartTime datetime2 GENERATED ALWAYS AS ROW START,
    SysEndTime datetime2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED (UserId ASC),
    CONSTRAINT FK_User_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
) WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UserHistory)
);

CREATE TABLE Payment (
    PaymentId integer IDENTITY (1, 1) NOT NULL,
    UserId integer NOT NULL,
    SubscriptionCode varchar(10) NOT NULL,
    Amount decimal(6, 2) NOT NULL,
    PaymentState varchar(20) NOT NULL,
    PostedDate datetime2 NOT NULL,
    SettledDate datetime2 NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    UpdatedOn datetime2 NULL,
    UpdatedBy nvarchar(100) NULL,
    SysStartTime datetime2 GENERATED ALWAYS AS ROW START,
    SysEndTime datetime2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
    CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED (PaymentId ASC),
    CONSTRAINT FK_Payment_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (UserId),
    CONSTRAINT FK_Payment_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
) WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PaymentHistory)
);

CREATE TABLE Genre (
    GenreId integer IDENTITY (1, 1) NOT NULL,
    GenreName varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Genre PRIMARY KEY CLUSTERED (GenreId ASC)
);

CREATE TABLE Artist (
    ArtistId integer IDENTITY (1, 1) NOT NULL,
    ArtistName nvarchar(100) NOT NULL,
    Biography nvarchar(MAX) NOT NULL,
    GenreId integer NOT NULL,
    FormationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
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
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY CLUSTERED (AlbumId ASC),
    CONSTRAINT FK_Album_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
);

CREATE TABLE Song (
    SongId integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    Duration time NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Song PRIMARY KEY CLUSTERED (SongId ASC)
);

CREATE TABLE ArtistAlbum (
    ArtistAlbumId integer IDENTITY (1, 1) NOT NULL,
    ArtistId integer NOT NULL,
    AlbumId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_ArtistAlbum PRIMARY KEY CLUSTERED (ArtistAlbumId ASC),
    CONSTRAINT FK_ArtistAlbum_ArtistId FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId),
    CONSTRAINT FK_ArtistAlbum_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (AlbumId)
);

CREATE TABLE Playlist (
    PlaylistId integer IDENTITY (1, 1) NOT NULL,
    Title varchar(100) NOT NULL,
    [Description] varchar(200),
    UserId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Playlist PRIMARY KEY CLUSTERED (PlaylistId ASC),
    CONSTRAINT FK_Playlist_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (UserId)
);

CREATE TABLE UserPlaylist (
    UserPlaylistId integer IDENTITY (1, 1) NOT NULL,
    UserId integer NOT NULL,
    PlaylistId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_UserPlaylist PRIMARY KEY CLUSTERED (UserPlaylistId ASC),
    CONSTRAINT FK_UserPlaylist_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (UserId),
    CONSTRAINT FK_UserPlaylist_Playlist_PlaylistId FOREIGN KEY (PlaylistId) REFERENCES Playlist (PlaylistId)
);

CREATE TABLE AlbumSong (
    AlbumId integer NOT NULL,
    SongId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_AlbumSong PRIMARY KEY CLUSTERED (AlbumId, SongId),
    CONSTRAINT FK_AlbumSong_Album_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (AlbumId),
    CONSTRAINT FK_AlbumSong_Song_SongId FOREIGN KEY (SongId) REFERENCES Song (SongId)
);

CREATE TABLE SongGenre (
    SongId integer NOT NULL,
    GenreId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_SongGenre PRIMARY KEY CLUSTERED (SongId, GenreId),
    CONSTRAINT FK_SongGenre_Song_SongId FOREIGN KEY (SongId) REFERENCES Song (SongId),
    CONSTRAINT FK_SongGenre_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
);

CREATE TABLE AlbumGenre (
    AlbumId integer NOT NULL,
    GenreId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_AlbumGenre PRIMARY KEY CLUSTERED (AlbumId, GenreId),
    CONSTRAINT FK_AlbumGenre_Album_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (AlbumId),
    CONSTRAINT FK_AlbumGenre_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
);
