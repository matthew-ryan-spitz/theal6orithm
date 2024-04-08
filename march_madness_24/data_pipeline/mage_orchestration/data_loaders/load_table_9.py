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
    url = 'MMasseyOrdinals.csv'
    dtypes = {'Season': pd.Int64Dtype(),
            'RankingDayNum': pd.Int64Dtype(),
            'SystemName': object,
            'TeamID': pd.Int64Dtype(),
            'OrdinalRank': pd.Int64Dtype()
            }

    return pd.read_csv('/home/src/mm_data/' + url, sep=',', dtype=dtypes)

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
