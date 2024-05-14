from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a BigQuery warehouse.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#bigquery
    """
    table_id = 'modular-cell-201815.stg_march_madness_2024.stg_tourney_seed_round_slots'
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    # switch to snake_case
    import re
    pattern = re.compile(r'([a-z0-9])([A-Z])')
    df.columns = [pattern.sub(r'\1_\2', col_name).lower() for col_name in df.columns.values]

    BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).export(
        df,
        table_id,
        if_exists='replace',  # Specify resolution policy if table name already exists
    )