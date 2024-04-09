{# returns round name of game played in nccaa tournament;
    results will be incorrect in 2021 season due to scheduling change #}

{% macro get_tourney_round_names(day_num) -%}

    case when {{day_num}} = 134 or {{day_num}} = 135 then 'play_in'
        when {{day_num}} = 136 or {{day_num}} = 137 then 'round_1'
        when {{day_num}} = 138 or {{day_num}} = 139 then 'round_2'
        when {{day_num}} = 143 or {{day_num}} = 144 then 'sweet_sixteen'
        when {{day_num}} = 145 or {{day_num}} = 146 then 'elite_eight'
        when {{day_num}} = 152 then 'final_four'
        when {{day_num}} = 154 then 'championship'
        else null
    end

{%- endmacro %}


{# returns location of game played from winning team's perspective #}

{% macro get_winning_team_location(wloc) -%}

    case when {{wloc}} = 'H' then 'home'
        when {{wloc}} = 'A' then 'away'
        when {{wloc}} = 'N' then 'neutral'
        else null
    end

{%- endmacro %}