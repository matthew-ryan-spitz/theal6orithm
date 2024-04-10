{{
    config(
        materialized='view'
    )
}}

-- missing complete 2024 rankings
with source as (

    select *,
        row_number() over(partition by season, ranking_day_num, system_name, team_id) as ranking_index
    from {{ source('staging', 'stg_team_rankings') }}

),

transformed as (

    select {{dbt_utils.generate_surrogate_key(['season', 'ranking_day_num', 'system_name', 'team_id'])}} as ranking_id,
        season,
        ranking_day_num,
        ranking_day_num - 1 as games_calculated_day_num,
        system_name,
        team_id,
        ordinal_rank
    from source
    -- remove dup games
    where ranking_index = 1
)

select * from transformed

{% if var('is_test_run', default=true) %}
    limit 100
{% endif %}