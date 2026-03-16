CREATE TABLE dim_users AS
SELECT
    UserProfileId,
    ApplicationId,
    CountryName,
    VIPSysname,
    Date AS ValidFromDate,
    LEAD(Date) OVER (
        PARTITION BY UserProfileId
        ORDER BY Date
    ) AS ValidToDate,
    CASE
        WHEN LEAD(Date) OVER (
            PARTITION BY UserProfileId
            ORDER BY Date
        ) IS NULL THEN 1
        ELSE 0
    END AS IsCurrent
FROM users;
