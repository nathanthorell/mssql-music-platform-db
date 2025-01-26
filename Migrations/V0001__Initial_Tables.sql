CREATE TABLE Subscription (
    Code varchar(10) NOT NULL,
    [Description] varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Subscription PRIMARY KEY CLUSTERED (Code ASC)
);

CREATE TABLE [User] (
    Id integer IDENTITY (1, 1) NOT NULL,
    [Name] nvarchar(100) NOT NULL,
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
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_User_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
) WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UserHistory)
);

CREATE TABLE Payment (
    Id integer IDENTITY (1, 1) NOT NULL,
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
    CONSTRAINT PK_Payment PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Payment_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (Id),
    CONSTRAINT FK_Payment_Subscription_SubscriptionCode FOREIGN KEY (SubscriptionCode) REFERENCES Subscription (Code)
) WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PaymentHistory)
);

CREATE TABLE Genre (
    Id integer IDENTITY (1, 1) NOT NULL,
    [Name] varchar(50) NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Genre PRIMARY KEY CLUSTERED (Id ASC)
);

CREATE TABLE Artist (
    Id integer IDENTITY (1, 1) NOT NULL,
    [Name] nvarchar(100) NOT NULL,
    Biography nvarchar(MAX) NOT NULL,
    GenreId integer NOT NULL,
    FormationDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Artist PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Artist_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (Id)
);

CREATE TABLE Album (
    Id integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    TotalDuration time NOT NULL,
    GenreId integer NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Album_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (Id)
);

CREATE TABLE Song (
    Id integer IDENTITY (1, 1) NOT NULL,
    Title nvarchar(100) NOT NULL,
    Duration time NOT NULL,
    ReleaseDate date NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Song PRIMARY KEY CLUSTERED (Id ASC)
);

CREATE TABLE ArtistAlbum (
    Id integer IDENTITY (1, 1) NOT NULL,
    ArtistId integer NOT NULL,
    AlbumId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_ArtistAlbum PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_ArtistAlbum_ArtistId FOREIGN KEY (ArtistId) REFERENCES Artist (Id),
    CONSTRAINT FK_ArtistAlbum_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (Id)
);

CREATE TABLE Playlist (
    Id integer IDENTITY (1, 1) NOT NULL,
    Title varchar(100) NOT NULL,
    [Description] varchar(200),
    UserId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_Playlist PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Playlist_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (Id)
);

CREATE TABLE UserPlaylist (
    Id integer IDENTITY (1, 1) NOT NULL,
    UserId integer NOT NULL,
    PlaylistId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_UserPlaylist PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_UserPlaylist_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (Id),
    CONSTRAINT FK_UserPlaylist_Playlist_PlaylistId FOREIGN KEY (PlaylistId) REFERENCES Playlist (Id)
);

CREATE TABLE AlbumSong (
    AlbumId integer NOT NULL,
    SongId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_AlbumSong PRIMARY KEY CLUSTERED (AlbumId, SongId),
    CONSTRAINT FK_AlbumSong_Album_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (Id),
    CONSTRAINT FK_AlbumSong_Song_SongId FOREIGN KEY (SongId) REFERENCES Song (Id)
);

CREATE TABLE SongGenre (
    SongId integer NOT NULL,
    GenreId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_SongGenre PRIMARY KEY CLUSTERED (SongId, GenreId),
    CONSTRAINT FK_SongGenre_Song_SongId FOREIGN KEY (SongId) REFERENCES Song (Id),
    CONSTRAINT FK_SongGenre_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (Id)
);

CREATE TABLE AlbumGenre (
    AlbumId integer NOT NULL,
    GenreId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_AlbumGenre PRIMARY KEY CLUSTERED (AlbumId, GenreId),
    CONSTRAINT FK_AlbumGenre_Album_AlbumId FOREIGN KEY (AlbumId) REFERENCES Album (Id),
    CONSTRAINT FK_AlbumGenre_Genre_GenreId FOREIGN KEY (GenreId) REFERENCES Genre (Id)
);
