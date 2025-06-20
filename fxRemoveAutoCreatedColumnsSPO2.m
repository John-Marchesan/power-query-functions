// fxRemoveAutoCreatedColumnsSPO2.m
// This Power Query M function is designed for use with the SharePoint Online connector Implementation 2.0.
// It removes common auto-generated columns from SharePoint list queries.

// ----------------------------
// How to Use This Function:
// ----------------------------
// 1. Open Power BI or Excel Power Query Editor.
// 2. Create a new blank query.
// 3. Open the Advanced Editor and paste this entire code block.
// 4. Rename the query to: fxRemoveAutoCreatedColumnsSPO2
// 5. In your main query, click the "fx" button in the formula bar to create a new step.
// 6. Call the function like this:
//      fxRemoveAutoCreatedColumnsSPO2(Source)
//    Replace 'Source' with the name of your SharePoint list query step.

let
    fxRemoveAutoCreatedColumnsSPO2 = (inputTable as table) as table =>
    let
        columnsToRemoveTable = #table(
            {"ColumnName", "Remove"},
            {
                {"Color Tag", true},
                {"Compliance Asset Id", true},
                {"Content Type", true},
                {"Modified", true},
                {"Created", true},
                {"Created By", true},
                {"Modified By", true},
                {"Version", true},
                {"Attachments", true},
                {"Edit", true},
                {"Type", true},
                {"Item Child Count", true},
                {"Folder Child Count", true},
                {"Label setting", true},
                {"Retention label", true},
                {"Retention label Applied", true},
                {"Label applied by", true},
                {"Item is a Record", true},
                {"App Created By", true},
                {"App Modified By", true},
                {"ID", false},
                {"Title", true}
            }
        ),
        filteredColumns = Table.SelectRows(columnsToRemoveTable, each [Remove] = true),
        columnNamesToRemove = List.Intersect({Table.ColumnNames(inputTable), filteredColumns[ColumnName]}),
        cleanedTable = Table.RemoveColumns(inputTable, columnNamesToRemove)
    in
        cleanedTable
in
    fxRemoveAutoCreatedColumnsSPO2
