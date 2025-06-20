
// Minor Change to test pipeline to git hub
// second test
// third test

// fxCheckRecordFound
// This function expands a nested table column (typically from a merge),
// checks if a related child record exists by evaluating a GUID field,
// adds a logical column (true/false), and removes the expanded GUID column.
//
// PARAMETERS:
//   sourceTable        - The input table (type: table)
//   columnToExpand     - The name of the column to expand (type: text, e.g., "PROD_people")
//                        This is typically the result of a merge with a related child table.
//   targetGuidField    - The name of the GUID field inside the nested table (type: text, e.g., "guid0")
//   newColumnName      - The name of the new column to create (type: text, e.g., "Person Record Found")
//
// NOTE: All text parameters must be enclosed in double quotes when calling the function.

(sourceTable as table, columnToExpand as text, targetGuidField as text, newColumnName as text) as table =>
let
    // Construct the name of the expanded column (e.g., "PROD_people.guid0")
    expandedColumnName = columnToExpand & "." & targetGuidField,

    // Expand the nested column to extract the GUID field
    expanded = Table.ExpandTableColumn(sourceTable, columnToExpand, {targetGuidField}, {expandedColumnName}),

    // Add a new column that checks if the GUID is not null (returns true/false)
    addedColumn = Table.AddColumn(expanded, newColumnName, each Record.Field(_, expandedColumnName) <> null, type logical),

    // Remove the expanded GUID column to clean up the table
    removedGuid = Table.RemoveColumns(addedColumn, {expandedColumnName})
in
    removedGuid
