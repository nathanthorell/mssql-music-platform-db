-- Sample data for the Subscription table
INSERT INTO Subscription (Code, [Description])
VALUES
('Free', 'Free Plan'),
('Trial', 'Two Week Trial of Pro Plan'),
('Pro', 'Professional Plan'),
('Premium', 'Premium unlimited'),
('Lifetime', 'Lifetime Premium');
GO

-- Sample data for the User table
INSERT INTO [User] (UserName, Email, SubscriptionCode, RegistrationDate)
VALUES
('John Doe', 'john.doe@example.com', 'Premium', '2023-07-01'),
('Jane Smith', 'jane.smith@example.com', 'Free', '2023-06-15'),
('Mike Johnson', 'mike.johnson@example.com', 'Premium', '2023-07-10'),
('Emily Adams', 'emily.adams@example.com', 'Free', '2023-06-28'),
('Alex Lee', 'alex.lee@example.com', 'Premium', '2023-07-05');
GO

-- Sample data for the Payment table with "Pending" PaymentState
INSERT INTO [Payment] (UserId, SubscriptionCode, Amount, PaymentState, PostedDate)
SELECT
    UserId,
    SubscriptionCode,
    CASE
        WHEN SubscriptionCode = 'Free' THEN 0.00
        WHEN SubscriptionCode = 'Trial' THEN 0.00
        WHEN SubscriptionCode = 'Pro' THEN 19.99
        WHEN SubscriptionCode = 'Premium' THEN 49.99
        WHEN SubscriptionCode = 'Lifetime' THEN 199.99
    END AS Amount,
    CASE
        WHEN [User].SubscriptionCode IN ('Free', 'Trial') THEN 'None'
        ELSE 'Pending' -- Default PaymentState for other cases
    END AS PaymentState,
    '2023-08-01' AS PostedDate
FROM [User];
GO

-- Sample data for the Genre table
INSERT INTO Genre (GenreName)
VALUES
('Rock'),
('Pop'),
('Hip-Hop'),
('Jazz'),
('Electronic');
GO

-- Sample data for the Artist table
INSERT INTO Artist (ArtistName, Biography, GenreId, FormationDate)
VALUES
('The Beatles', 'The Beatles were an English rock band formed in Liverpool in 1960.', 1, '1960-03-01'),
('Taylor Swift', 'Taylor Swift is an American singer-songwriter.', 2, '2006-10-24'),
('Eminem', 'Eminem is an American rapper, songwriter, and record producer.', 3, '1988-04-01'),
('Miles Davis', 'Miles Davis was an American jazz trumpeter, bandleader, and composer.', 4, '1945-05-26'),
('Daft Punk', 'Daft Punk was a French electronic music duo.', 5, '1993-01-01');
GO

-- Sample data for the Album table
INSERT INTO Album (Title, TotalDuration, GenreId, ReleaseDate)
VALUES
('Abbey Road', '01:00:00', 1, '1969-09-26'),
('1989', '00:50:00', 2, '2014-10-27'),
('The Marshall Mathers LP', '01:15:00', 3, '2000-05-23'),
('Kind of Blue', '00:45:00', 4, '1959-08-17'),
('Random Access Memories', '01:00:00', 5, '2013-05-17');
GO

-- Additional sample data for the Song table
INSERT INTO Song (Title, Duration, ReleaseDate)
VALUES
('Something', '00:03:03', '1969-09-26'),
('Come Together', '00:04:18', '1969-09-26'),
('While My Guitar Gently Weeps', '00:04:45', '1968-11-22'),
('Here, There and Everywhere', '00:02:25', '1966-08-05'),
('Back to December', '00:04:53', '2010-10-12'),
('Blank Space', '00:03:51', '2014-08-18'),
('Bad Guy', '00:03:14', '2019-03-29'),
('Love the Way You Lie', '00:04:23', '2010-08-09'),
('The Real Slim Shady', '00:04:44', '2000-05-16'),
('So What', '00:09:22', '1959-08-17'),
('Blue in Green', '00:05:37', '1959-08-17'),
('All Blues', '00:11:34', '1959-08-17'),
('Lose Yourself', '00:05:26', '2002-10-22'),
('The Way I Am', '00:04:50', '2000-05-23'),
('Superheroes', '00:03:58', '2014-05-02'),
('Get Lucky', '00:06:10', '2013-04-19'),
('Instant Crush', '00:05:37', '2013-05-17'),
('Doin'' It Right', '00:04:11', '2013-05-17');
GO

-- Sample data for the Playlist table
INSERT INTO Playlist (Title, [Description], UserID)
VALUES
('Road Trip Playlist', 'Perfect for your next road adventure!', 1),
('Chill & Relax', 'Unwind with these soothing tunes.', 2),
('Gym Workout Playlist', 'Motivation for your workout sessions.', 3),
('Soothing Jazz', 'Relax with smooth jazz melodies.', 2),
('Best of Daft Punk', 'Time to dance!', 1);
GO

-- Sample data for the UserPlaylist table
INSERT INTO UserPlaylist (UserID, PlaylistID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(2, 4),
(1, 5);
GO

-- Additional sample data for the AlbumSong table
INSERT INTO AlbumSong (AlbumID, SongID)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12),
(4, 13),
(4, 14),
(4, 15),
(5, 16),
(5, 17),
(5, 18);
GO

-- Sample data for the SongGenre table
INSERT INTO SongGenre (SongID, GenreID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
GO

-- Sample data for the AlbumGenre table
INSERT INTO AlbumGenre (AlbumID, GenreID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
GO

-- Sample data for the ArtistAlbum table
INSERT INTO ArtistAlbum (ArtistId, AlbumId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
GO
