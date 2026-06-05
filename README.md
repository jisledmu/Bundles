# Databricks ETL Project with Asset Bundles

## Descripción

Este proyecto implementa un proceso ETL utilizando Databricks Asset Bundles (DAB), Unity Catalog y Lakeflow Declarative Pipelines.

El flujo permite cargar archivos CSV desde un Volume de Unity Catalog, almacenarlos como tablas Delta y posteriormente ejecutar un pipeline que genera una vista materializada para el consumo de datos procesados.

## Arquitectura

```text
CSV Files
    │
    ▼
Unity Catalog Volume (inputs)
    │
    ▼
Notebook create_table
    │
    ▼
Delta Table (ventas)
    │
    ▼
Lakeflow Declarative Pipeline
    │
    ▼
Materialized View (processed_data)
```

## Estructura del Proyecto

```text
Bundles/

├── databricks.yml

├── resources/
│   ├── schema.yml
│   ├── volume.yml
│   ├── job.yml
│   └── elt.pipeline.yml

├── src/
│   ├── notebooks/
│   │   └── create_table.ipynb
│   │
│   └── pipeline_elt/
│       └── transformations/
│           └── etl_pipeline.sql

└── README.md
```

## Tecnologías Utilizadas

* Databricks Asset Bundles (DAB)
* Unity Catalog
* Delta Lake
* Lakeflow Declarative Pipelines
* Apache Spark
* SQL
* Python

## Recursos Implementados

### Schema

Se crea un schema dentro del catálogo configurado para almacenar tablas, vistas y volúmenes del proyecto.

### Volume

Se crea un Volume denominado `inputs` para almacenar los archivos CSV de entrada.

Ruta utilizada:

```text
/Volumes/<catalog>/<schema>/inputs/
```

### Notebook

El notebook `create_table.ipynb` realiza las siguientes tareas:

* Lectura de archivos CSV desde Unity Catalog Volumes.
* Inferencia automática de esquema.
* Conversión a formato Delta.
* Creación o reemplazo de la tabla `ventas`.

### Workflow

El workflow `ventas_workflow` contiene:

1. Tarea `create_table`

   * Carga los datos desde el Volume.
   * Genera la tabla Delta.

2. Tarea `execute_pipeline`

   * Ejecuta el pipeline ETL.
   * Genera la vista materializada.

### Pipeline

El pipeline procesa los datos de la tabla `ventas` y genera una vista materializada denominada `processed_data`.

Ejemplo de transformación:

```sql
CREATE OR REFRESH MATERIALIZED VIEW processed_data
COMMENT 'Processed sales data'
AS
SELECT
    *,
    current_timestamp() AS processed_at
FROM ventas;
```

## Configuración de Entornos

El proyecto soporta múltiples entornos:

* Development (`dev`)
* Quality Assurance (`qa`)
* Production (`prod`)

Configurados mediante Databricks Asset Bundles.

## Despliegue

### Validar Bundle

```bash
databricks bundle validate
```

### Desplegar en Desarrollo

```bash
databricks bundle deploy -t dev
```

### Desplegar en QA

```bash
databricks bundle deploy -t qa
```

### Desplegar en Producción

```bash
databricks bundle deploy -t prod
```

## Flujo de Ejecución

1. Cargar archivos CSV en el Volume `inputs`.
2. Ejecutar el workflow o esperar la activación por File Arrival Trigger.
3. Crear la tabla Delta `ventas`.
4. Ejecutar el pipeline ETL.
5. Generar la vista materializada `processed_data`.

## Resultado Esperado

```text
Catalog
└── data-growth
    └── <schema>
        ├── Volumes
        │   └── inputs
        │
        ├── Tables
        │   └── ventas
        │
        └── Materialized Views
            └── processed_data
```

## Autor

Proyecto desarrollado como práctica de Databricks Asset Bundles, Unity Catalog y Lakeflow Declarative Pipelines.
