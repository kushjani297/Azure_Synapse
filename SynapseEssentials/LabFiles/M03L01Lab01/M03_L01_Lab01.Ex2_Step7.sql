SELECT t.DateID,
       t.HackneyLicenseID,
       SUM(t.[TripDistanceMiles]) AS MilesDriven
FROM Trip_MedallionID_Skewed t
WHERE MedallionID IN (Select MedallionID FROM [dbo].[Medallion_HD])
GROUP BY t.DateID,
         t.HackneyLicenseID
OPTION (Label = 'Skewed Data Query')