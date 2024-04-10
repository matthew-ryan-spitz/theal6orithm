{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by season, seed) as seed_index
    from (
        select season,
            seed,
            team_id
        from {{ source('staging', 'stg_tourney_seeds_historical') }}

        union all

        select 2024 as season,
            seed,
            team_id
        from {{ source('staging', 'stg_tourney_seeds') }}
        where tournament = 'M'
    )

),

transformed as (

    select {{dbt_utils.generate_surrogate_key(['season', 'seed'])}} as seed_id,
        season,
        seed,
        team_id
    from source
    -- remove dup seeds
    where seed_index = 1
)

select * from transformed

{% if var('is_test_run', default=true) %}
    limit 100
{% endif %}