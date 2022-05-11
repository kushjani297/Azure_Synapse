--Monitor how the data is being read from external files and
--how that data is being converted to SQL data type format and how it is being written to Synapse SQL Pool distributions
Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
WHERE r.[label] = 'CTAS:HashPaymentType'


--Monitor how many writers were used to distribute the data
Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
WHERE r.[label] = 'CTAS:HashPaymentType'
and type = 'WRITER' and bytes_processed <> 0