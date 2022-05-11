IF( object_id ('Trip_MedallionID_Skewed')) IS NOT NULL DROP TABLE Trip_MedallionID_Skewed
GO

-- Copy the Trip table, HASHED on MedallionID, combined with the copy with NULL in the HASH key
CREATE TABLE Trip_MedallionID_Skewed
WITH ( DISTRIBUTION = HASH ( [MedallionID] ),
       CLUSTERED COLUMNSTORE INDEX )
AS 
SELECT *
FROM [Trip_MedallionID]
UNION
SELECT *
FROM [Trip_MedallionID_NULL]