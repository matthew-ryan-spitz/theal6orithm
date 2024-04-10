{{
    config(
        materialized='table'
    )
}}


-- join season
-- join team_ids to get team names and seeds
-- join seeds to get slots and matchups
with output as (
    select tr.game_id,
        tr.season,
        s.day_zero + tr.day_num as game_date,
        tr.day_num,
        tr.tourney_round_name,
        srs.game_round as tourney_round_number,
        srs.game_slot,
        ss.strong_seed,
        ss.weak_seed,
        tr.winning_team_id,
        t1.team_name as winning_team_name,
        sd1.seed as winning_team_seed,
        case when srs.game_round > 1 then sd1.seed - substr(ss.strong_seed, 4) as winning_team_strong_seed_delta,
        case when srs.game_round > 1 then sd1.seed - substr(ss.weak_seed, 4) as winning_team_weak_seed_delta,
        tr.losing_team_id,
        t2.team_name as losing_team_name,
        sd2.seed as losing_team_seed,
        case when srs.game_round > 1 then sd2.seed - substr(ss.strong_seed, 4) as losing_team_strong_seed_delta,
        case when srs.game_round > 1 then sd2.seed - substr(ss.weak_seed, 4) as losing_team_weak_seed_delta,
        tr.winning_team_score,
        tr.losing_team_score,
        tr.winning_team_location,
        case when tr.winning_team_location = 'home' then 1 else 0 end as home_win_flag
    from {{ ref('stg_tourney_results_compact') }} as tr
    left join {{ ref('stg_teams') }} as t1
        on tr.winning_team_id = t.team_id
    left join {{ ref('stg_teams') }} as t2
        on tr.losing_team_id = t.team_id
    left join {{ ref('stg_seasons') }} as s
        on tr.season = s.season
    left join {{ ref('stg_tourney_seeds') }} as sd1
        on tr.season = sd1.season
            and winning_team_id.team_id = sd1.team_id
    left join {{ ref('stg_tourney_seeds') }} as sd2
        on tr.season = sd2.season
            and losing_team_id.team_id = sd2.team_id
    left join {{ ref('stg_tourney_seed_round_slots') }} as srs
        on sd1.seed = srs.seed
            and tr.day_num between srs.early_day_num and srs.late_day_num
    left join {{ ref('stg_tourney_slots') }} as ss
        on tr.season = ss.season
            and srs.game_slot = ss.slot
)

select * from output