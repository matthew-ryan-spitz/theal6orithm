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
    import os
    os.system("kaggle competitions download -c march-machine-learning-mania-2024")
    os.system("unzip march-machine-learning-mania-2024.zip -d mm_data/")
