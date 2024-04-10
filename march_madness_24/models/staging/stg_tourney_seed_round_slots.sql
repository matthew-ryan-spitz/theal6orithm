{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by seed, game_slot) as seed_slot_index
    from {{ source('staging', 'stg_tourney_seed_round_slots') }}

),

transformed as (

    select {{dbt_utils.generate_surrogate_key(['seed', 'game_slot'])}} as seed_slot_id,
        seed,
        game_slot,
        game_round,
        early_day_num,
        late_day_num
    from source
    -- remove dup slots
    where seed_slot_index = 1
)

select * from transformed

{% if var('is_test_run', default=true) %}
    limit 100
{% endif %}