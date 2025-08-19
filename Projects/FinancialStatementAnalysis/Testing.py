# %%
!pip install morethemes

# %%
import requests
import sys 
import os 
sys.path.append(os.path.abspath(os.path.join(os.getcwd(), '..', '..')))
from credential import FMP_API_KEY
from highlight_text import ax_text,fig_text
import pandas as pd
import matplotlib.pyplot as plt 

import morethemes as mt 

# %%
url = "https://financialmodelingprep.com/api/v3/income-statement/AAPL"
params = {
    "period": "annual",
    "limit": 10,
    "apikey": FMP_API_KEY
}

r = requests.get(url, params=params, timeout=30)
data = r.json()
print(data)



# %%
df = pd.DataFrame(data)

# %%
df

# %% [markdown]
# ## Data cleaning
# - [x] remove unncessary columns: `fillingDate`, `acceptedDate`, `period`, `date`, `symbol`, `reportedCurrency`, `cik`, `link`, `fina`   - done
# - [x] display value in as proper format  - done 
# - [x] tranform the data from width to height - done 
#    

# %%
df.drop(columns=['fillingDate', 'acceptedDate', 'period', 'date', 'symbol', 'reportedCurrency', 'cik', 'link', 'finalLink'], inplace=True)

# %%
df

# %%
df_format = df.melt(
    id_vars=["calendarYear"],        # keep the year fixed
    var_name="Metric",               # new column for metric names
    value_name="Value"               # new column for metric values
)

# %%
df_format

# %%
df_revenue = df_format[df_format['Metric'] == 'revenue']
df_revenue

# %% [markdown]
# 

# %%
df_revenue['value_billion'] = df_revenue['Value']/100_000_000
df_revenue['value_billion'] = df_revenue['value_billion'].map("{:,.2f}".format)
df_revenue


# %%
df_revenue["calendarYear"] = (
    df_revenue["calendarYear"]
    .astype(str)                 # make sure everything is string
    .str.strip()                 # remove leading/trailing spaces
    .str.replace(r"\.0$", "", regex=True)  # drop '.0' if present
    .astype("Int32")                 # finally cast to int
)

# %%
print(df_revenue['calendarYear'].unique())

# %%
type(df_revenue.loc[0, "calendarYear"]), df_revenue["calendarYear"].unique()


# %%
df_revenue["value_billion"] = (
    df_revenue["value_billion"].astype(str).str.replace(",", "", regex=False)
    .pipe(pd.to_numeric, errors="coerce")
)

# %%
df_revenue.info() 

# %% [markdown]
# # To follow up:  
# - try writing a function that appy value formatting (e.i add comma between thousand) to the select list of columns  

# %%
# step 1, populate the draft chart to visualize 

fig, ax = plt.subplots()
x = df_revenue['calendarYear']
y = df_revenue['value_billion']
ax.bar(
    x,y
)
ax = ax 

plt.show()

# %%
# step 2:  
# remove the border line 
# remove y value   
# starting number of y value to be 0, while the max value is 5000   

fig, ax = plt.subplots()
x = df_revenue['calendarYear']
y = df_revenue['value_billion']
bar_container = ax.bar(x,y)
for spine in ['top','right','bottom','left']:
    ax.spines[spine].set_visible(False),
# ax.set_xticks([])
ax.set_yticks([]) # to remove border line,
ax.tick_params(length=0), # to remove x - ticks,
plt.ylim(0,5000),  # starting number of y value to be 0, while the max value is 5000   
ax.bar_label(bar_container, label_type='edge', fmt=lambda x: f'{x:,.2f}')
ax = bar_container

plt.show()

# %%
# step 2:  
# remove the border line 
# remove y value   
# starting number of y value to be 0, while the max value is 5000   

# step 3:  
# apply formating
# setting color for 2024, prior year to grey   

blue = '#0466c8'
grey = '#979dac'
colors = [
    blue if year == 2024 else grey
    for year in df_revenue["calendarYear"]
]

fig, ax = plt.subplots()
x = df_revenue['calendarYear']
y = df_revenue['value_billion']
bar_container = ax.bar(x,y,color = colors)
for spine in ['top','right','bottom','left']:
    ax.spines[spine].set_visible(False),
ax.set_yticks([]) # to remove border line,
ax.tick_params(length=0), # to remove x - ticks,
plt.ylim(0,5000),  # starting number of y value to be 0, while the max value is 5000   
ax.bar_label(bar_container, label_type='edge', fmt=lambda x: f'{x:,.2f}')
ax = bar_container



plt.show()

# %%
def cagr(begin_value, end_value, periods):
    return (end_value / begin_value) ** (1/periods) - 1    

# %%
start_year = df_revenue['calendarYear'].min()
end_year = df_revenue['calendarYear'].max()

begin_value = df_revenue.loc[df_revenue['calendarYear'] == start_year,'value_billion'].values[0]
end_value = df_revenue.loc[df_revenue['calendarYear'] == end_year,'value_billion'].values[0]
periods = end_year - start_year 

# %%
apple_cagr = cagr(begin_value, end_value, periods )
apple_cagr

# %%
# step 2:  
## remove the border line 
## remove y value   
## starting number of y value to be 0, while the max value is 5000   

# step 3:  
## apply formating
## setting color for 2024, prior year to grey   

# step 4:  
## add chart title 
## add chart sub title  

blue = '#0466c8'
grey = '#979dac'
colors = [
    blue if year == 2024 else grey
    for year in df_revenue["calendarYear"]
]

fig, ax = plt.subplots()

x = df_revenue['calendarYear']
y = df_revenue['value_billion']
bar_container = ax.bar(x,y,color = colors)
for spine in ['top','right','bottom','left']:
    ax.spines[spine].set_visible(False),
ax.set_yticks([]) # to remove border line,
ax.tick_params(length=0), # to remove x - ticks,
plt.ylim(0,5000),  # starting number of y value to be 0, while the max value is 5000   
ax.bar_label(bar_container, label_type='edge', fmt=lambda x: f'{x:,.2f}')
ax = bar_container

# add title 
fig.text(x = .17, y = .9 ,s='Apple Revenue, 2020 - 2024 (in millions)',color=blue,fontsize = 'x-large', fontweight = 'bold')
# add sub title 
fig_text(x = .17, y = .87 ,s=f"Apple's revenues increased steadily over 5 years,\nwith a <CAGR> of <{apple_cagr * 100:.2f}> % per year.", highlight_textprops=[{'color':blue,'fontweight':'bold'} , {'color':blue,'fontweight':'bold'}  ])
# add credit  
fig.text(x = .17, y = 0, s = 'By: Thinh Doan | Data source: financialmodelingprep.com', color = grey, fontsize = 'x-small')
plt.show()



# %% [markdown]
# # Data Visualization

# %% [markdown]
# What are the steps: 
# - Draft visual
#   - Chart title: Apple 5 Year Revenue Performance (2020 - 2025) 
#   - Chart subtitle: Apple revenues show steady increase over 5 year with xx% a year 
#   - Chart credit: viz by: ThinhD, data source: FMP, 
#     - [x] to calculate for CARG ratio 
#   - Chart type - Chart color - Color pallets
#     - [x] use https://y-sunflower.github.io/morethemes/#__tabbed_1_6    
#     - => Decided to not use theme as I want to make more control of the chart   
# 
# 
# Make chart showing cartoon style - 
# https://matplotlib.org/stable/gallery/showcase/xkcd.html#sphx-glr-gallery-showcase-xkcd-py
# 

# %%
fig, ax = plt.subplot

# %% [markdown]
# 


