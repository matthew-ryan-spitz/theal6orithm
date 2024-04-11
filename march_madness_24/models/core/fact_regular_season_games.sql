{{
    config(
        materialized='table'
    )
}}

with output as (
    select tr.game_id,
        tr.season,
        date(s.day_zero) + tr.day_num as game_date,
        tr.day_num,
        tr.winning_team_id,
        t1.team_name as winning_team_name,
        trk1.ordinal_rank_system_avg as winning_team_rank_avg,
        tr.losing_team_id,
        t2.team_name as losing_team_name,
        trk2.ordinal_rank_system_avg as losing_team_rank_avg,
        tr.winning_team_score,
        tr.losing_team_score,
        tr.winning_team_location,
        case when tr.winning_team_location = 'home' then 1 else 0 end as home_win_flag,
        case when trk1.ordinal_rank_system_avg is null and trk2.ordinal_rank_system_avg is null then null
            when coalesce(trk1.ordinal_rank_system_avg, 0) < coalesce(trk2.ordinal_rank_system_avg, 0) then 1 else 0 end as favorite_win_flag
    from {{ ref('stg_regular_season_results_compact') }} as tr
    -- join team_ids
    left join {{ ref('stg_teams') }} as t1
        on tr.winning_team_id = t1.team_id
    left join {{ ref('stg_teams') }} as t2
        on tr.losing_team_id = t2.team_id
    -- join season
    left join {{ ref('stg_seasons') }} as s
        on tr.season = s.season
    -- join team_rankings
    left join {{ ref('mart_daily_team_rankings_agg')}} as trk1
        on tr.season = trk1.season
            and tr.winning_team_id = trk1.team_id
            and tr.day_num = trk1.day_num
    left join {{ ref('mart_daily_team_rankings_agg')}} as trk2
        on tr.season = trk2.season
            and tr.losing_team_id = trk2.team_id
            and tr.day_num = trk2.day_num
)

select * from output