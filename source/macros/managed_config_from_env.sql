{% macro get_schema_from_env(dataset_id_target) -%}

    {%- set default_schema = target.schema -%}
    {%- if var('env_dbt') == 'prod'-%}

        {{ dataset_id_target | trim }}

    {%- else -%}
        {{ default_schema }}
        
    {%- endif -%}

{%- endmacro %}