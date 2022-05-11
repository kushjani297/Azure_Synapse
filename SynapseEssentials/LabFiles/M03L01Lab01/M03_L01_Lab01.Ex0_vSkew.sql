/*
  ===========================================
     Create Skew View
  ===========================================
  This query will report the Skew, as:
    ( ( Max(Rows in a Distribution) - Max(Rows in a Distribution) ) / (Total rows in the table) ) * 100
  
*/

If object_id('vSkew') IS NOT NULL DROP VIEW vSkew 
GO

CREATE VIEW dbo.vSkew
AS
WITH TblDtls 
AS
(
SELECT	t.[name]				AS  [table_name],
		nt.[distribution_id]	AS  [distribution_id],
		nps.[row_count]			AS  [row_count]
	FROM sys.tables t
		INNER JOIN sys.pdw_table_mappings tm
			ON t.[object_id] = tm.[object_id]
		INNER JOIN sys.pdw_nodes_tables nt
			ON tm.[physical_name] = nt.[name]
		INNER JOIN sys.dm_pdw_nodes pn
			ON  nt.[pdw_node_id] = pn.[pdw_node_id]
		INNER JOIN sys.dm_pdw_nodes_db_partition_stats nps
			ON nt.[object_id] = nps.[object_id]
			AND nt.[pdw_node_id] = nps.[pdw_node_id]
			AND nt.[distribution_id] = nps.[distribution_id]
	WHERE pn.[type] = 'COMPUTE'
)
SELECT	table_name,
		( ((MAX(row_count) * 1.0) - (MIN(row_count) * 1.0)) / (SUM(row_count) * 1.0) ) * 100.0 AS Skew
	FROM tblDtls
	GROUP BY table_name
