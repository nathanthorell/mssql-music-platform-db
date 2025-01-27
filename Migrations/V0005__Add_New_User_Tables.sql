CREATE TABLE UserActivity (
    Id integer IDENTITY (1, 1) NOT NULL,
    UserId integer NOT NULL,
    SongId integer NOT NULL,
    ActivityType varchar(20) NOT NULL,
    DurationListened time NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    UpdatedOn datetime2 NULL,
    UpdatedBy nvarchar(100) NULL,
    SysStartTime datetime2 GENERATED ALWAYS AS ROW START,
    SysEndTime datetime2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
    CONSTRAINT PK_UserActivity PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_UserActivity_User_UserId FOREIGN KEY (UserId) REFERENCES [User] (Id),
    CONSTRAINT FK_UserActivity_Song_SongId FOREIGN KEY (SongId) REFERENCES [Song] (Id),
    CONSTRAINT CK_UserActivity_ActivityType CHECK (ActivityType IN ('Played', 'Skipped', 'Liked'))
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UserActivityHistory));

CREATE TABLE UserFollow (
    Id integer IDENTITY (1, 1) NOT NULL,
    FollowerUserId integer NOT NULL,
    FollowedUserId integer NOT NULL,
    CreatedBy nvarchar(100) NOT NULL,
    CreatedOn datetime2 NOT NULL,
    CONSTRAINT PK_UserFollow PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_UserFollow_Follower_UserId FOREIGN KEY (FollowerUserId) REFERENCES [User] (Id),
    CONSTRAINT FK_UserFollow_Followed_UserId FOREIGN KEY (FollowedUserId) REFERENCES [User] (Id),
    CONSTRAINT UQ_UserFollow_Users UNIQUE (FollowerUserId, FollowedUserId)
);
