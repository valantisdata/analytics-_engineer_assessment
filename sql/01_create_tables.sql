CREATE TABLE casinodaily (
    UpdatedTimestamp TIMESTAMP,
    userid INT,
    ApplicationId TEXT,
    CountryName TEXT,
    CurrencyId INT,
    p_Date DATE,
    GameName TEXT,
    ProviderName TEXT,
    ManufacturerName TEXT,
    Turnover FLOAT,
    Returns FLOAT,
    GGR FLOAT
);

CREATE TABLE users (
    UserProfileId INT,
    ApplicationId TEXT,
    VIPSysname TEXT,
    CountryName TEXT,
    Date DATE
);

CREATE TABLE currencyrates (
    Date DATE,
    FromCurrencyId INT,
    ToCurrencyId INT,
    ToCurrencySysname TEXT,
    EuroRate FLOAT
);
