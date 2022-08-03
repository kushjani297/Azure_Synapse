-------------------slow queries using largerc------------------

EXECUTE AS User = 'synmonProcessUser'; 

SELECT *
FROM [synmon].[fctTrip_RR] rr
	INNER JOIN [synmon].[fctTrip_MedallionID] m
	ON rr.[MedallionID] = m.[MedallionID] 
		AND rr.DateID = m.DateID
WHERE rr.DateID between '20130301' and '20130331'
	AND m.DateID between '20130301' and '20130331'
--30 seconds


SELECT *
FROM [synmon].[fctTrip_HackneyLicenseID] hl
	INNER JOIN [synmon].[fctTrip_MedallionID] m
	ON hl.HackneyLicenseID = m.HackneyLicenseID 
		AND hl.DateID = m.DateID
WHERE hl.DateID between '20130301' and '20130331'
	AND m.DateID between '20130301' and '20130331'


SELECT *
FROM [synmon].[fctTrip_MedallionID] m
	INNER JOIN [synmon].[fctTrip_MedallionID_BIGINT] bi
	ON m.[MedallionID] = bi.[MedallionID] 
		AND bi.DateID = m.DateID
WHERE m.DateID between '20130301' and '20130331'
	AND bi.DateID between '20130301' and '20130331'


REVERT;




