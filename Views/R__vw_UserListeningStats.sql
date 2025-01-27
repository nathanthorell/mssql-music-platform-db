CREATE OR ALTER VIEW vw_UserListeningStats
AS
SELECT
    u.Id AS UserId,
    u.Name AS UserName,
    COUNT(DISTINCT ua.SongId) AS UniqueSongsPlayed,
    COUNT(CASE WHEN ua.ActivityType = 'Liked' THEN 1 END) AS TotalLikes,
    COUNT(CASE WHEN ua.ActivityType = 'Skipped' THEN 1 END) AS TotalSkips,
    SUM(CASE
        WHEN ua.ActivityType = 'Played'
            THEN DATEDIFF(SECOND, '00:00:00', ua.DurationListened)
        ELSE 0
    END) / 3600.0 AS TotalHoursListened
FROM [User] u
LEFT JOIN UserActivity ua ON u.Id = ua.UserId
GROUP BY u.Id, u.Name;
