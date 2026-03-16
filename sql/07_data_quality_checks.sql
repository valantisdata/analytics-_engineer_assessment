-- 1 Timestamp validity
SELECT COUNT(*) AS invalid_timestamps
FROM casinodaily
WHERE UpdatedTimestamp IS NULL
   OR p_Date IS NULL;

-- 2 Currency rate coverage
SELECT COUNT(*) AS missing_currency_rates
FROM casino_with_currency
WHERE EuroRate IS NULL;

-- 3 Financial metric validation
SELECT
    ROUND(AVG(ABS(GGR_EUR - (Turnover_EUR - Returns_EUR)))::numeric, 4) AS avg_difference,
    ROUND(MAX(ABS(GGR_EUR - (Turnover_EUR - Returns_EUR)))::numeric, 4) AS max_difference
FROM casino_with_currency;

-- 4 VIP coverage distribution
SELECT VIPSysname, COUNT(*)
FROM casino_vip_status
GROUP BY VIPSysname
ORDER BY COUNT(*) DESC;

-- 5 Duplicate detection in Gold table
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
    COUNT(*)
FROM gold_table
GROUP BY
    UpdatedTimestamp,
    ApplicationId,
    CountryName,
    VIPSysname,
    CurrencySysname,
    p_Date,
    GameName,
    ProviderName,
    ManufacturerName
HAVING COUNT(*) > 1;
