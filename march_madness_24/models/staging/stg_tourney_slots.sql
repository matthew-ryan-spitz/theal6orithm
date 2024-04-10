{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by season, slot) as slot_index
    from {{ source('staging', 'stg_tourney_slots') }}

),

transformed as (

    select {{dbt_utils.generate_surrogate_key(['season', 'slot'])}} as slot_id,
        season,
        slot,
        strong_seed,
        weak_seed
    from source
    -- remove dup slots
    where slot_index = 1
)

select * from transformed

{% if var('is_test_run', default=true) %}
    limit 100
{% endif %}