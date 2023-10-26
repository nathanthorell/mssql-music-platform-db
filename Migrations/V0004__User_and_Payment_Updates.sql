-- Update Emily Adams' subscription to 'Trial'
UPDATE [User]
SET SubscriptionCode = 'Trial'
WHERE Email = 'emily.adams@example.com';
GO

-- Update Mike Johnson's subscription to 'Pro'
UPDATE [User]
SET SubscriptionCode = 'Pro'
WHERE Email = 'mike.johnson@example.com';
GO

-- Update Alex Lee's email to 'alexlee@newexample.com'
UPDATE [User]
SET Email = 'alexlee@newexample.com'
WHERE Email = 'alex.lee@example.com';
GO

-- Update Payment records to simulate processing payments
-- Update John Doe's payment to Processed
UPDATE [Payment]
SET
    PaymentState = 'Processed',
    SettledDate = GETDATE(),
    UpdatedOn = GETDATE(),
    UpdatedBy = 'PaymentApp',
    Amount = CASE
        WHEN SubscriptionCode = 'Pro' THEN 19.99
        WHEN SubscriptionCode = 'Premium' THEN 49.99
        WHEN SubscriptionCode = 'Lifetime' THEN 199.99
        ELSE Amount
    END
WHERE UserId = (SELECT UserId FROM [User] WHERE Email = 'john.doe@example.com');
GO

-- Update Mike Johnson's payment to Processed
UPDATE [Payment]
SET
    PaymentState = 'Processed',
    SettledDate = GETDATE(),
    UpdatedOn = GETDATE(),
    UpdatedBy = 'PaymentApp',
    Amount = CASE
        WHEN SubscriptionCode = 'Pro' THEN 19.99
        WHEN SubscriptionCode = 'Premium' THEN 49.99
        WHEN SubscriptionCode = 'Lifetime' THEN 199.99
        ELSE Amount
    END
WHERE UserId = (SELECT UserId FROM [User] WHERE Email = 'mike.johnson@example.com');
GO

-- Update Alex Lee's payment to Processed
UPDATE [Payment]
SET
    PaymentState = 'Processed',
    SettledDate = GETDATE(),
    UpdatedOn = GETDATE(),
    UpdatedBy = 'PaymentApp',
    Amount = CASE
        WHEN SubscriptionCode = 'Pro' THEN 19.99
        WHEN SubscriptionCode = 'Premium' THEN 49.99
        WHEN SubscriptionCode = 'Lifetime' THEN 199.99
        ELSE Amount
    END
WHERE UserId = (SELECT UserId FROM [User] WHERE Email = 'alexlee@newexample.com');
GO
