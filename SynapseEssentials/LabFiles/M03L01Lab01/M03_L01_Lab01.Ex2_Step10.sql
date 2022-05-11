IF( object_id ('Geography_Repl')) IS NOT NULL	DROP TABLE Geography_Repl
GO

CREATE TABLE Geography_Repl 
WITH (DISTRIBUTION = REPLICATE,
      HEAP )
AS
SELECT *
FROM [dbo].[Geography]

-- Force the Replicated table into cache
SELECT TOP 1 *
FROM Geography_Repl 
