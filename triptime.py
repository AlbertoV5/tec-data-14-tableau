# %%
import pandas as pd
from pathlib import Path


resources = Path('resources')
df = pd.read_csv(resources / 'citibike-ready.csv')

# %%
mknum = lambda x: 60 * x[0] + x[1] + x[2]/60
frmt = lambda x: mknum([float(i) for i in x.split(" ")[1].split(':')])
df['minutes'] = df['tripduration'].map(frmt)
df.to_csv(resources / 'citibike-minutes.csv')
#%%
bikeid = df.groupby(df['bikeid'])
bikeid.sum()['minutes']