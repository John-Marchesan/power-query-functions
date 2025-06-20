// fxRemoveAutoCreatedColumnsSPO1.m
// This Power Query M function is designed for use with the SharePoint Online connector (Implementation 1.0).
// It removes a predefined set of auto-generated columns from a SharePoint list query.

// ---------------------------
//  Instructions for Use:
// ---------------------------
// 1. Open Power BI or Excel Power Query Editor.
// 2. Create a new blank query.
// 3. Open the Advanced Editor and paste this entire code block.
// 4. Rename the query to: fxRemoveAutoCreatedColumnsSPO1
// 5. To use the function:
//    - In the Queries pane, click the "fx" button to create a new query that calls a function.
//    - In the formula bar, enter the function call like this:
//        fxRemoveAutoCreatedColumnsSPO1(Source)
//      where 'Source' is the name of your SharePoint list query or table.
// ---------------------------

let
    fxRemoveAutoCreatedColumnsSPO1 = (inputTable as table) as table =>
    let
        columnsToRemoveTable = #table(
            {"ColumnName", "Remove"},
            {
                {"FileSystemObjectType", true},
                {"Id", true},
                {"ServerRedirectedEmbedUri", true},
                {"ServerRedirectedEmbedUrl", true},
                {"ContentTypeId", true},
                {"OData__ColorTag", true},
                {"ComplianceAssetId", true},
                {"Modified", true},
                {"Created", true},
                {"AuthorId", true},
                {"EditorId", true},
                {"OData__UIVersionString", true},
                {"Attachments", true},
                {"GUID", true},
                {"FirstUniqueAncestorSecurableObject", true},
                {"RoleAssignments", true},
                {"AttachmentFiles", true},
                {"ContentType", true},
                {"GetDlpPolicyTip", true},
                {"FieldValuesAsHtml", true},
                {"FieldValuesAsText", true},
                {"FieldValuesForEdit", true},
                {"File", true},
                {"Folder", true},
                {"LikedByInformation", true},
                {"ParentList", true},
                {"Properties", true},
                {"Versions", true},
                {"Author", true},
                {"Editor", true},
                {"Title", true},
                {"ID", false}
            }
        ),
        filteredColumns = Table.SelectRows(columnsToRemoveTable, each [Remove] = true),
        columnNamesToRemove = List.Intersect({Table.ColumnNames(inputTable), filteredColumns[ColumnName]}),
        cleanedTable = Table.RemoveColumns(inputTable, columnNamesToRemove)
    in
        cleanedTable
in
    fxRemoveAutoCreatedColumnsSPO1
