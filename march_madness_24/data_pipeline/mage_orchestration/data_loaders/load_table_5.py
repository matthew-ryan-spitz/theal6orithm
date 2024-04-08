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
    url = 'MRegularSeasonCompactResults.csv'
    dtypes = {'Season': pd.Int64Dtype(),
            'DayNum': pd.Int64Dtype(),
            'WTeamID': pd.Int64Dtype(),
            'WScore': pd.Int64Dtype(),
            'LTeamID': pd.Int64Dtype(),
            'LScore': pd.Int64Dtype(),
            'WLoc': object,
            'NumOT':  pd.Int64Dtype()
            }

    return pd.read_csv('/home/src/mm_data/' + url, sep=',', dtype=dtypes)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
