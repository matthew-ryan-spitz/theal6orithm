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
    url = 'MSeasons.csv'
   
    dtypes = {'Season': pd.Int64Dtype(),
            'DayZero': object,
            'RegionW': object,
            'RegionX': object,
            'RegionY': object,
            'RegionZ': object
            }
    
    df = pd.read_csv('/home/src/mm_data/' + url, sep=',', dtype=dtypes)
    df['DayZero'] = pd.to_datetime(df['DayZero'])

    return df


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
