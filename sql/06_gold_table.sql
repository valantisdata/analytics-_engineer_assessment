CREATE TABLE gold_table AS
SELECT
    UpdatedTimestamp,
    ApplicationId,
    CountryName,
    VIPSysname,
    CurrencySysname,
    p_Date,
    GameName,
    ProviderName,
    ManufacturerName,
    SUM(Turnover_EUR) AS Turnover,
    SUM(Returns_EUR) AS Returns,
    SUM(GGR_EUR) AS GGR
FROM casino_vip_status
GROUP BY
    UpdatedTimestamp,
    ApplicationId,
    CountryName,
    VIPSysname,
    CurrencySysname,
    p_Date,
    GameName,
    ProviderName,
    ManufacturerName;
