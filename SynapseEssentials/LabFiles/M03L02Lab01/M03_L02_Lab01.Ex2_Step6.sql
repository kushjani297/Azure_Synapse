SET RESULT_SET_CACHING OFF
GO

SELECT c.*
FROM
    (SELECT b.County,
            b.city,
            count(a.dateid) AS total_trips,
            rank() OVER (PARTITION BY b.county
                        ORDER BY count(a.dateid) DESC) AS rank
    FROM dbo.Trip a
    LEFT JOIN dbo.Geography b ON a.[PickupGeographyID] = b.[GeographyID]
    WHERE [State] = 'NY'
    GROUP BY b.County,
            b.city) c
WHERE rank <=3
    AND total_trips > 100
ORDER BY County,
            City,
            total_trips,
            rank
OPTION (Label = 'MV Query')
