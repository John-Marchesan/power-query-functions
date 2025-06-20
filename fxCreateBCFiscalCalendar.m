// ================================================
// FUNCTION: fxCreateBCFiscalCalendar
// DESCRIPTION:
// Generates a calendar table with BC fiscal year data
// between a given StartDate and EndDate.
//
// INSTRUCTIONS:
// 1. Open Power Query Editor in Excel or Power BI.
// 2. Go to "Home" > "New Source" > "Blank Query".
// 3. Open the "Advanced Editor".
// 4. Delete any existing code and paste this entire block.
// 5. Rename the query to: fxCreateBCFiscalCalendar (or "CreateCalendar").
// 6. Click on the fxCreateBCFiscalCalendar function in the Queries pane,
//    enter your desired StartDate and EndDate, and rename the resulting
//    query to something like "BC Calendar".
// ================================================

(StartDate as date, EndDate as date) as table =>
let
    // Generate list of dates from StartDate to EndDate
    DateList = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),

    // Add calendar components
    AddYear = Table.AddColumn(DateTable, "Year", each Date.Year([Date]), Int64.Type),
    AddMonth = Table.AddColumn(AddYear, "Month", each Date.Month([Date]), Int64.Type),
    AddDay = Table.AddColumn(AddMonth, "Day", each Date.Day([Date]), Int64.Type),

    // Add fiscal year logic (BC fiscal year starts in April)
    AddFiscalYear = Table.AddColumn(AddDay, "FiscalYear", each if [Month] > 3 then [Year] + 1 else [Year]),
    AddFiscalYearText = Table.AddColumn(AddFiscalYear, "FiscalYearName", each "FY" & Text.End(Text.From([FiscalYear]), 2)),

    // Add FiscalYearName_2: "YY/YY" format
    AddFYName2 = Table.AddColumn(AddFiscalYearText, "FiscalYearName_2", each 
        Text.End(Text.From([FiscalYear] - 1), 2) & "/" & Text.End(Text.From([FiscalYear]), 2)),

    // Add FiscalYearName_3: "YYYY/YYYY" format
    AddFYName3 = Table.AddColumn(AddFYName2, "FiscalYearName_3", each 
        Text.From([FiscalYear] - 1) & "/" & Text.From([FiscalYear])),

    // Add period name: month abbreviation + last 2 digits of fiscal year
    AddMonthAbbrev = Table.AddColumn(AddFYName3, "MonthAbbrev", each Text.Upper(Date.ToText([Date], "MMM"))),
    AddPeriodName = Table.AddColumn(AddMonthAbbrev, "PeriodName", each [MonthAbbrev] & "-" & Text.End(Text.From([FiscalYear]), 2)),

    // Add fiscal quarter
    AddQuarter = Table.AddColumn(AddPeriodName, "FiscalQuarter", each 
        if [Month] >= 4 and [Month] <= 6 then "Q1" else
        if [Month] >= 7 and [Month] <= 9 then "Q2" else
        if [Month] >= 10 and [Month] <= 12 then "Q3" else "Q4"),

    // Remove helper column
    RemoveMonthAbbrev = Table.RemoveColumns(AddQuarter, {"MonthAbbrev"}),

    // Reorder columns to show FiscalYear first
    Reordered = Table.ReorderColumns(RemoveMonthAbbrev, {
        "Date", "FiscalYear", "FiscalYearName", "FiscalYearName_2", "FiscalYearName_3",
        "PeriodName", "FiscalQuarter", "Year", "Month", "Day"
    })
in
    Reordered
