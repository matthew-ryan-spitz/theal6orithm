{{ codegen.generate_model_yaml(
    model_names = [ 'stg_teams',
      'stg_seasons',
      'stg_regular_season_results_compact',
      'stg_tourney_results_compact',
      'stg_team_rankings',
      'stg_tourney_seeds',
      'stg_tourney_slots',
      'stg_tourney_seed_round_slots',
      'dim_seasons',
      'dim_teams',
      'fact_regular_season_games',
      'fact_tourney_games',
      'mart_daily_team_rankings_agg'
]
) }}