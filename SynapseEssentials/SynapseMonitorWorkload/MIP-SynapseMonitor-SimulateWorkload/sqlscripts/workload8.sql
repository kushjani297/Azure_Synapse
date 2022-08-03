-------------------aggregate queries using smallrc------------------

EXECUTE AS User = 'synmonNormalUser'; 

SELECT G.geographyid,T.TimeID,P.PassengerCount,
      SUM(P.TripDistanceMiles) as SumTripDistance,
      AVG(P.TripDistanceMiles) as AvgTripDistance,
      SUM(P.FareAmount) as SumFareAmount,
      AVG(P.FareAmount) as AvgFareAmount,
      SUM(P.TaxAmount) as SumTaxAmount,
      AVG(P.TaxAmount) as AvgTaxAmount,
      SUM(P.TotalAmount) as SumTotalAmount,
      AVG(P.TotalAmount) as AvgTotalAmount
FROM [synmon].[fctTrip] P
	INNER JOIN [synmon].[Geography] G
		ON P.pickupgeographyid = G.geographyid
	INNER JOIN [synmon].[Time] T
		ON T.TimeID = P.PickupTimeId
WHERE P.DateID between '20130301' and '20130331'
GROUP BY P.PassengerCount,G.geographyid,T.TimeID
OPTION (LABEL = 'Result Set Caching')

REVERT;



