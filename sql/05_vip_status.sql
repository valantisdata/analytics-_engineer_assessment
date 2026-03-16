CREATE TABLE casino_vip_status AS
SELECT
    a.UpdatedTimestamp,
    a.userid,
    a.ApplicationId,
    a.CountryName,
    COALESCE(b.VIPSysname, 'UNKNOWN') AS VIPSysname,
    a.CurrencySysname,
    a.p_Date,
    a.GameName,
    a.ProviderName,
    a.ManufacturerName,
    a.Turnover_EUR,
    a.Returns_EUR,
    a.GGR_EUR
FROM casino_with_currency a
LEFT JOIN dim_users b
    ON a.userid = b.UserProfileId
   AND a.ApplicationId = b.ApplicationId
   AND a.p_Date >= b.ValidFromDate
   AND (a.p_Date < b.ValidToDate OR b.ValidToDate IS NULL);
