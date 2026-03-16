CREATE TABLE casino_with_currency AS
SELECT
    a.UpdatedTimestamp,
    a.userid,
    a.ApplicationId,
    a.CountryName,
    a.CurrencyId,
    b.ToCurrencySysname AS CurrencySysname,
    a.p_Date,
    a.GameName,
    a.ProviderName,
    a.ManufacturerName,
    a.Turnover,
    a.Returns,
    a.GGR,
    b.EuroRate,
    a.Turnover * b.EuroRate AS Turnover_EUR,
    a.Returns * b.EuroRate AS Returns_EUR,
    a.GGR * b.EuroRate AS GGR_EUR
FROM casinodaily a
LEFT JOIN currencyrates b
    ON a.CurrencyId = b.ToCurrencyId
   AND a.p_Date = b.Date;
