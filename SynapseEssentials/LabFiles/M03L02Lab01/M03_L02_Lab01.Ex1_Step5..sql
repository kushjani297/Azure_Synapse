ALTER INDEX ALL ON Trip_MedallionID
	REBUILD;

SELECT *
FROM vCCI_Stats_Detail
WHERE Logical_Table_Name = 'Trip_MedallionID'
