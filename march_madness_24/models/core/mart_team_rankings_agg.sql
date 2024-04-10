{{
    config(
        materialized='table'
    )
}}

with output as (
    select r.season,
        r.ranking_day_num,
        r.team_id,
        t.team_name,
        round(avg(r.ordinal_rank),0) as ordinal_rank_system_avg,
        round(max(r.ordinal_rank),0) as ordinal_rank_system_max,
        round(min(r.ordinal_rank),0) as ordinal_rank_system_min
    from {{ ref('stg_team_rankings') }} as r
    left join {{ ref('stg_teams') }} as t
        on r.team_id = t.team_id
    group by 1,2,3,4
)

select * from output