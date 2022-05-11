EXPLAIN
SELECT *
FROM Trip_MedallionID t
INNER JOIN Medallion_HD m
ON t.MedallionID = m.MedallionID


EXPLAIN
SELECT *
FROM Trip_HackneyLicenseID t
INNER JOIN Medallion_HD m
ON t.MedallionID = m.MedallionID
