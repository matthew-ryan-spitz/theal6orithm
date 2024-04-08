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
    url = 'MNCAATourneySlots.csv'
    dtypes = {'Season': pd.Int64Dtype(),
            'Slot': object,
            'StrongSeed': object,
            'WeakSeed': object
            }

    return pd.read_csv('/home/src/mm_data/' + url, sep=',', dtype=dtypes)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
