# %%
import matplotlib.pyplot as plt 
import seaborn as sns
import pandas as pd

# %%
url = "https://raw.githubusercontent.com/jennybc/gapminder/master/data-raw/08_gap-every-five-years.tsv"
df = pd.read_csv(url, sep='\t')

# %%
df.head(20)

# %%
# Filter data for the years 1952 and 1957
years = [1952, 1957]
df = df[df['year'].isin(years)]

# %%
df

# %%
# Calculate average gdp, per continent, per year
df = df.groupby(['continent', 'year'])['gdpPercap'].mean().unstack()

# %%
df

# %%
def add_label(continent_name, year):
    
    # Calculate value (and round it)
    y_position = round(df[year][continent_name])
    
    # Determine x_position depending on the year  
    if year==1952:
        x_position = year - 1.2
    else:
        x_position = year + 0.12
    
    # Adding the text
    plt.text(x_position, # x-axis position
             y_position, #y-axis position
             f'{continent_name}, {y_position}', # Text
             fontsize=8, # Text size
             color='black', # Text color
            ) 

# %%
for continent_name in df.index:
    for year in df.columns:
        print(continent_name, year)
          

# %%
# Set figsize
plt.figure(figsize=(6, 8))

# Vertical lines for the years
plt.axvline(x=years[0], color='black', linestyle='--', linewidth=1) # 1952
plt.axvline(x=years[1], color='black', linestyle='--', linewidth=1) # 1957

# Add the BEFORE and AFTER
plt.text(1951, 11000, 'BEFORE', fontsize=12, color='black', fontweight='bold')
plt.text(1957.1, 11000, 'AFTER', fontsize=12, color='black', fontweight='bold')

# Plot the line for each continent
for continent in df.index:
    
    # Color depending on the evolution
    value_before = df[df.index==continent][years[0]][0] #gdp/cap of the continent in 1952
    value_after = df[df.index==continent][years[1]][0] #gdp/cap of the continent in 1957
    
    # Red if the value has decreased, green otherwise
    if value_before > value_after:
        color='red'
    else:
        color='green'
    
    # Add the line to the plot
    plt.plot(years, df.loc[continent], marker='o', label=continent, color=color)

plt.show()

# %%
# Set figsize
plt.figure(figsize=(6, 8))

# Vertical lines for the years
plt.axvline(x=years[0], color='black', linestyle='--', linewidth=1) # 1952
plt.axvline(x=years[1], color='black', linestyle='--', linewidth=1) # 1957

# Add the BEFORE and AFTER
plt.text(1951, 11000, 'BEFORE', fontsize=12, color='black', fontweight='bold')
plt.text(1957.1, 11000, 'AFTER', fontsize=12, color='black', fontweight='bold')

# Plot the line for each continent
for continent in df.index:
    
    # Color depending on the evolution
    value_before = df[df.index==continent][years[0]][0] #gdp/cap of the continent in 1952
    value_after = df[df.index==continent][years[1]][0] #gdp/cap of the continent in 1957
    
    # Red if the value has decreased, green otherwise
    if value_before > value_after:
        color='red'
    else:
        color='green'
    
    # Add the line to the plot
    plt.plot(years, df.loc[continent], marker='o', label=continent, color=color)

# Add label of each continent at each year
for continent_name in df.index:
    for year in df.columns:
        add_label(continent_name, year)


plt.show()

# %%
# Set figsize
plt.figure(figsize=(6, 8))

# Vertical lines for the years
plt.axvline(x=years[0], color='black', linestyle='--', linewidth=1) # 1952
plt.axvline(x=years[1], color='black', linestyle='--', linewidth=1) # 1957

# Add the BEFORE and AFTER
plt.text(1951, 11000, 'BEFORE', fontsize=12, color='black', fontweight='bold')
plt.text(1957.1, 11000, 'AFTER', fontsize=12, color='black', fontweight='bold')

# Plot the line for each continent
for continent in df.index:
    
    # Color depending on the evolution
    value_before = df[df.index==continent][years[0]][0] #gdp/cap of the continent in 1952
    value_after = df[df.index==continent][years[1]][0] #gdp/cap of the continent in 1957
    
    # Red if the value has decreased, green otherwise
    if value_before > value_after:
        color='red'
    else:
        color='green'
    
    # Add the line to the plot
    plt.plot(years, df.loc[continent], marker='o', label=continent, color=color)

# Add label of each continent at each year
for continent_name in df.index:
    for year in df.columns:
        add_label(continent_name, year)

# Add a title ('\n' allow us to jump lines)
plt.title(f'Slope Chart: \nComparing GDP Per Capita between {years[0]} vs {years[1]}  \n\n\n') 

plt.yticks([]) # Remove y-axis
plt.box(False) # Remove the bounding box around plot

plt.show()

# %%



