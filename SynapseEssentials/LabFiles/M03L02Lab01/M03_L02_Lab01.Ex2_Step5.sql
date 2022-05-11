CREATE MATERIALIZED VIEW mv_TripGeography 
WITH (DISTRIBUTION = HASH(County)) AS
SELECT [b].[County],
       [b].[City] ,
       [b].[State],
       COUNT(*) AS [Expr3]
FROM [dbo].[Trip] a,
     [dbo].[Geography] b
WHERE [b].[GeographyID]=[a].[PickupGeographyID]
GROUP BY [b].[County],
         [b].[City],
         [b].[State]
