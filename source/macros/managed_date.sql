{% macro get_current_date() %}
    '{{ var("current_date") }}'
{% endmacro %}

{% macro get_begin_date() %}
    '{{ var("begin_date") }}'
{% endmacro %}

{% macro get_end_date() %}
    '{{ var("end_date") }}'
{% endmacro %}
