{{
    config(
        materialized='table'
    )
}}

with team_rankings as (
    select r.season,
        r.games_calculated_day_num,
        r.team_id,
        t.team_name,
        round(avg(r.ordinal_rank),0) as ordinal_rank_system_avg,
        round(max(r.ordinal_rank),0) as ordinal_rank_system_max,
        round(min(r.ordinal_rank),0) as ordinal_rank_system_min
    from {{ ref('stg_team_rankings') }} as r
    left join {{ ref('stg_teams') }} as t
        on r.team_id = t.team_id
    group by 1,2,3,4
),

output as (
    select *
    from team_rankings as tr
    cross join unnest(generate_array(0, {{ var('max_game_day_num') }} )) as day_num
    where tr.games_calculated_day_num < day_num
    qualify row_number() over(partition by season, day_num, team_id, team_name order by games_calculated_day_num desc) = 1
)

select * from output