-- Lakeflow Spark Declarative Pipeline (DLT)
-- This pipeline creates a materialized view from the raw_data table

-- Create Materialized View
CREATE OR REFRESH MATERIALIZED VIEW processed_data
COMMENT 'Datos procesados desde la tabla ventas'
AS
SELECT
    *,
    current_timestamp() AS processed_at
FROM ventas;
