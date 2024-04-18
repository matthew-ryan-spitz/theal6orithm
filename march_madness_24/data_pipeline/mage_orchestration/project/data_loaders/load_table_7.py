import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    url = 'MRegularSeasonDetailedResults.csv'
    dtypes = {'Season': pd.Int64Dtype(),
            'DayNum': pd.Int64Dtype(),
            'WTeamID': pd.Int64Dtype(),
            'WScore': pd.Int64Dtype(),
            'LTeamID': pd.Int64Dtype(),
            'LScore': pd.Int64Dtype(),
            'WLoc': object,
            'NumOT': pd.Int64Dtype(),
            'WFGM': pd.Int64Dtype(),
            'WFGA': pd.Int64Dtype(),
            'WFGM3': pd.Int64Dtype(),
            'WFGA3': pd.Int64Dtype(),
            'WFTM': pd.Int64Dtype(),
            'WFTA': pd.Int64Dtype(),
            'WOR': pd.Int64Dtype(),
            'WDR': pd.Int64Dtype(),
            'WAst': pd.Int64Dtype(),
            'WTO': pd.Int64Dtype(),
            'WStl': pd.Int64Dtype(),
            'WBlk': pd.Int64Dtype(),
            'WPF': pd.Int64Dtype(),
            'LFGM': pd.Int64Dtype(),
            'LFGA': pd.Int64Dtype(),
            'LFGM3': pd.Int64Dtype(),
            'LFGA3': pd.Int64Dtype(),
            'LFTM': pd.Int64Dtype(),
            'LFTA': pd.Int64Dtype(),
            'LOR': pd.Int64Dtype(),
            'LDR': pd.Int64Dtype(),
            'LAst': pd.Int64Dtype(),
            'LTO': pd.Int64Dtype(),
            'LStl': pd.Int64Dtype(),
            'LBlk': pd.Int64Dtype(),
            'LPF': pd.Int64Dtype()
            }

    return pd.read_csv('/home/src/mm_data/' + url, sep=',', dtype=dtypes)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
