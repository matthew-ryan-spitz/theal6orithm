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
        tr.tourney_round_name,
        srs.game_round as tourney_round_number,
        srs.game_slot,
        ss.strong_seed,
        ss.weak_seed,

        tr.winning_team_id,
        t1.team_name as winning_team_name,
        trk1.ordinal_rank_system_avg as winning_team_rank_avg,
        sd1.seed as winning_team_seed,

        tr.losing_team_id,
        t2.team_name as losing_team_name,
        trk2.ordinal_rank_system_avg as losing_team_rank_avg,
        sd2.seed as losing_team_seed,

        tr.winning_team_score,
        tr.losing_team_score,
        tr.winning_team_location,
        case when tr.winning_team_location = 'home' then 1 else 0 end as home_win_flag,
        case when trk1.ordinal_rank_system_avg is null and trk2.ordinal_rank_system_avg is null then null
            when coalesce(trk1.ordinal_rank_system_avg, 1000000) < coalesce(trk2.ordinal_rank_system_avg, 1000000) then 1 else 0 end as favorite_rank_win_flag,
        case when 
            (case when sd1.seed like '%a%' or sd1.seed like '%b%' then cast(substr(sd1.seed,2,2) as int64) else cast(substr(sd1.seed,-2) as int64) end) 
            
            < 
            
            (case when sd2.seed like '%a%' or sd2.seed like '%b%' then cast(substr(sd2.seed,2,2) as int64) else cast(substr(sd2.seed,-2) as int64) end) 
              
         then 1 else 0 end as favorite_seed_win_flag
    from {{ ref('stg_tourney_results_compact') }} as tr
    -- join team_ids
    left join {{ ref('stg_teams') }} as t1
        on tr.winning_team_id = t1.team_id
    left join {{ ref('stg_teams') }} as t2
        on tr.losing_team_id = t2.team_id
    -- join season
    left join {{ ref('stg_seasons') }} as s
        on tr.season = s.season
    -- join seeds to get slots and matchups
    left join {{ ref('stg_tourney_seeds') }} as sd1
        on tr.season = sd1.season
            and tr.winning_team_id = sd1.team_id
    left join {{ ref('stg_tourney_seeds') }} as sd2
        on tr.season = sd2.season
            and tr.losing_team_id = sd2.team_id
    left join {{ ref('stg_tourney_seed_round_slots') }} as srs
        on sd1.seed = srs.seed
            and tr.day_num between srs.early_day_num and srs.late_day_num
    left join {{ ref('stg_tourney_slots') }} as ss
        on tr.season = ss.season
            and srs.game_slot = ss.slot
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