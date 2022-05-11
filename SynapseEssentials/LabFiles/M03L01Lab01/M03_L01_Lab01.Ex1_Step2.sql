DBCC PDW_SHOWSPACEUSED ('Trip_MedallionID');
SELECT *
FROM vSkew
WHERE Table_Name = 'Trip_MedallionID';


DBCC PDW_SHOWSPACEUSED ('Trip_MedallionID_Null');
SELECT *
FROM vSkew
WHERE Table_Name = 'Trip_MedallionID_Null';


DBCC PDW_SHOWSPACEUSED ('Trip_MedallionID_Dflt');
SELECT *
FROM vSkew
WHERE Table_Name = 'Trip_MedallionID_Dflt';


DBCC PDW_SHOWSPACEUSED ('Trip_RR');
SELECT *
FROM vSkew
WHERE Table_Name = 'Trip_RR';




