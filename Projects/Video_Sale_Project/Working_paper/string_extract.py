import pandas as pd
import numpy as np
from fuzzywuzzy import fuzz
from fuzzywuzzy import process
from collections import defaultdict
import re

# Read the CSV file
df = pd.read_csv(r'C:\Users\dqthi\Testing\vgsales_with_franchises.csv')

# Function to clean game names for better matching
def clean_name(name):
    # Remove version numbers, edition info, etc.
    cleaned = re.sub(r'\([^)]*\)', '', name)  # Remove parentheses contents
    cleaned = re.sub(r':.*$', '', cleaned)     # Remove everything after colon
    cleaned = re.sub(r'\d+$', '', cleaned)     # Remove trailing numbers
    return cleaned.strip()

# Extract base franchise name (heuristic approach)
def extract_franchise_name(name):
    # Common patterns for franchise names
    patterns = [
        r'^(.*?):', # Main series name followed by a colon
        r'^(.*?)\s[-–]', # Main series name followed by a dash
        r'^(.*?)\s\d+$', # Main series name followed by a number (e.g., "Final Fantasy 7")
        r'^(.*?)\s[IVXLCDM]+$' # Main series name followed by Roman numerals
    ]
    
    for pattern in patterns:
        match = re.search(pattern, name)
        if match:
            return match.group(1).strip()
    
    # If no patterns match, return cleaned name
    return clean_name(name)

# Get all game names and extract potential franchise names
games = df['Name'].tolist()
franchise_names = [extract_franchise_name(name) for name in games]

# Create a mapping of franchise names to all games in that franchise
franchises = defaultdict(list)

# Group games into franchises based on fuzzy matching
processed_games = set()
threshold = 85  # Similarity threshold

# First pass: group exact franchise matches
for i, game in enumerate(games):
    base_franchise = franchise_names[i]
    if game not in processed_games:
        franchises[base_franchise].append(game)
        processed_games.add(game)

# Second pass: use fuzzy matching for remaining games
for game in games:
    if game in processed_games:
        continue
        
    # Find the best matching franchise
    matches = process.extractBests(
        clean_name(game), 
        franchises.keys(), 
        scorer=fuzz.token_sort_ratio, 
        score_cutoff=threshold,
        limit=1
    )
    
    if matches:
        best_match, score = matches[0]
        franchises[best_match].append(game)
    else:
        # Create a new franchise for this game
        base_name = extract_franchise_name(game)
        franchises[base_name].append(game)
    
    processed_games.add(game)

# Sort franchises by size (largest first)
sorted_franchises = sorted(franchises.items(), key=lambda x: len(x[1]), reverse=True)

# Print results
print(f"Grouped {len(games)} games into {len(franchises)} franchises")
print("\nTop 10 largest franchises:")
for franchise, games_list in sorted_franchises[:10]:
    print(f"\n{franchise} ({len(games_list)} games):")
    for game in games_list[:5]:  # Show first 5 games in each franchise
        print(f"  - {game}")
    if len(games_list) > 5:
        print(f"  - ... and {len(games_list) - 5} more")

# Create a new DataFrame with franchise information
result_data = []
for franchise, games_list in franchises.items():
    for game in games_list:
        # Find the publisher for this game
        publisher = df[df['Name'] == game]['Publisher'].values[0] if len(df[df['Name'] == game]) > 0 else "Unknown"
        result_data.append({
            'Name': game,
            'Publisher': publisher,
            'Franchise': franchise
        })

result_df = pd.DataFrame(result_data)

# Save the result to a new CSV file
result_df.to_csv('game_franchises.csv', index=False)
print(f"\nResults saved to 'game_franchises.csv'")