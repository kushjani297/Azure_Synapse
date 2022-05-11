EXPLAIN
SELECT *
FROM [dbo].[Trip_RR] t
INNER JOIN [dbo].[Geography] g
ON t.[PickupGeographyID] = g.[GeographyID]
