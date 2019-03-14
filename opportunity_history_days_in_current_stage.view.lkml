view: opportunity_history_days_in_current_stage {
  derived_table: {
    sql:
    WITH stage_changes AS (

    -- Get the created date for every opportunity
    SELECT DISTINCT id as opportunity_id, created_date
    FROM salesforce.opportunity

    UNION ALL

    -- Get the date that every change to StageName from opportunity history for each id
    SELECT DISTINCT opportunity_id, created_date
    FROM opportunity_field_history
    WHERE field = 'StageName'
    )

    SELECT opportunity_id, MAX(created_date) as most_recent_stage_change
    FROM stage_changes
    GROUP BY 1 ;;
  }

  dimension_group: most_recent_stage_change {
    type: time
    datatype: timestamp
    sql: ${TABLE}.most_recent_stage_change ;;
  }

  dimension: opportunity_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.opportunity_id ;;
  }
}