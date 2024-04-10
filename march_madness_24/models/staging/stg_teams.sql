{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by team_id) as team_index
    from {{ source('staging', 'stg_teams') }}

),

transformed as (

    select team_id,
        team_name,
        first_d1_season,
        last_d1_season,
        last_d1_season - first_d1_season as d1_active_years
    from source
    -- remove dup teams
    where team_index = 1
)

select * from transformed