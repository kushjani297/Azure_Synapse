EXPLAIN
SELECT *
FROM [dbo].[Trip_RR] t
INNER JOIN [dbo].[Geography_Repl] g
ON t.[PickupGeographyID] = g.[GeographyID]
