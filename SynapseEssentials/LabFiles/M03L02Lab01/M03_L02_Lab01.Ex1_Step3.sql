SELECT *
FROM vCCI_Stats_Detail
WHERE [logical_table_name] = 'Trip_MedallionID'
ORDER BY physical_name, row_group_id

SELECT *
FROM vCCIHealth
WHERE Table_Name = 'Trip_MedallionID'
