{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by season) as season_index
    from {{ source('staging', 'stg_seasons') }}

),

transformed as (

    select season,
        day_zero,
        region_w,
        region_x,
        region_y,
        region_z
    from source
    -- remove dup seasons
    where season_index = 1
)

select * from transformed