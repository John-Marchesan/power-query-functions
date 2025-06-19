// ================================================
// INSTRUCTIONS:
// 1. Open Power Query Editor in Excel or Power BI.
// 2. Go to "Home" > "New Source" > "Blank Query".
// 3. Open the "Advanced Editor".
// 4. Delete any existing code and paste this entire block.
// 5. Rename the query to: fxGetBCFiscalData
// 6. To use the function, go to your data table,
//    then use "Add Column" > "Invoke Custom Function"
//    and select fxGetBCFiscalData, passing in your date column.
// ================================================

(inputDateTime as any) as record =>
let
    // Ensure the input is treated as a date
    inputDate = Date.From(inputDateTime),
    year = Date.Year(inputDate),
    month = Date.Month(inputDate),
    day = Date.Day(inputDate),

    // Fiscal year logic (BC fiscal year starts in April)
    fiscalYear = if month > 3 then year + 1 else year,
    fiscalYearText = "FY" & Text.End(Text.From(fiscalYear), 2),

    // Period name: month abbreviation + last 2 digits of fiscal year
    monthAbbrev = Text.Upper(Date.ToText(inputDate, "MMM")),
    periodName = monthAbbrev & "-" & Text.End(Text.From(fiscalYear), 2),

    // Fiscal quarter logic
    quarter = 
        if month >= 4 and month <= 6 then "Q1" else
        if month >= 7 and month <= 9 then "Q2" else
        if month >= 10 and month <= 12 then "Q3" else
        "Q4",

    // FiscalYearName_2: "YY/YY" format
    fyStartShort = Text.End(Text.From(fiscalYear - 1), 2),
    fyEndShort = Text.End(Text.From(fiscalYear), 2),
    fiscalYearName2 = fyStartShort & "/" & fyEndShort,

    // FiscalYearName_3: "YYYY/YYYY" format
    fiscalYearName3 = Text.From(fiscalYear - 1) & "/" & Text.From(fiscalYear)
in
    [
        FiscalYearName = fiscalYearText,
        FiscalYearName_2 = fiscalYearName2,
        FiscalYearName_3 = fiscalYearName3,
        PeriodName = periodName,
        FiscalQuarter = quarter,
        CalendarYear = year,
        CalendarMonth = month,
        CalendarDay = day
    ]
