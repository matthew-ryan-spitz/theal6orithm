with source as (

    select * from {{ source('staging', 'stg_tourney_results_compact') }}

),

transformed as (

    select {{dbt_utils.generate_surrage_key(['season', 'day_num', 'wteam_id'])}} as game_id,
        season,
        day_num,
        {{ get_tourney_round_names('day_num') }} as tourney_round_name,
        wteam_id as winning_team_id,
        wscore as winning_team_score,
        lteam_id as losing_team_id,
        lscore as losing_team_score,
        {{ get_winning_team_location('wloc') }} as winning_team_location
    from source
)

select * from transformed