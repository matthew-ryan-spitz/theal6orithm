{{
    config(
        materialized='view'
    )
}}

with source as (

    select *,
        row_number() over(partition by season, day_num, wteam_id) as game_index
    from {{ source('staging', 'stg_regular_season_results_compact') }}

),

quartiles as (
    select approx_quantiles(day_num, 3)[safe_offset(0)] as quartile_1,
        approx_quantiles(day_num, 3)[safe_offset(1)] as quartile_2,
        approx_quantiles(day_num, 3)[safe_offset(2)] as quartile_3,
        approx_quantiles(day_num, 3)[safe_offset(3)] as quartile_4
    from source
),

transformed as (

    select {{dbt_utils.generate_surrogate_key(['season', 'day_num', 'wteam_id'])}} as game_id,
        season,
        day_num,
        case when day_num < (select quartile_2 from quartiles) then 1
            when day_num >= (select quartile_2 from quartiles) and day_num < (select quartile_3 from quartiles) then 2
            when day_num >= (select quartile_3 from quartiles) and day_num <= (select quartile_4 from quartiles) then 3
        end as regular_season_games_played_quartile,
        wteam_id as winning_team_id,
        wscore as winning_team_score,
        lteam_id as losing_team_id,
        lscore as losing_team_score,
        {{ get_winning_team_location('wloc') }} as winning_team_location,
        num_ot
    from source
    -- remove dup games
    where game_index = 1
)

select * from transformed

{% if var('is_test_run', default=false) %}
    limit 100
{% endif %}