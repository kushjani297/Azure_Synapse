SELECT TOP 10
    StateProvince,
    CAST(SUM(TotalIncludingTax) AS decimal(18,2)) AS [(sum) TotalIncludingTax],
    CAST(AVG(TotalIncludingTax) AS decimal(18,2)) AS [(avg) TotalIncludingTax]
  FROM wwi.DimCity AS D
  JOIN wwi.FactOrder F on F.citykey = D.citykey
 GROUP BY   Description, StateProvince
 ORDER BY 3 DESC

