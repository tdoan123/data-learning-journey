to represent a specific point in time, we use the Timestamp class instead of either the datetime.datetime class that comes with Python or the `np.datetime64` class that comes with NumPy.

`pd.to_datetime('now')` to get the time now  

`pd.to_datetime()`

`pd.read_csv(filename,
            parse_dates=['birthday', 'anniversary'])`

```
s.dt.month         # month number
s.dt.month_name    # month name
s.dt.hour          # hour
s.dt.day_of_week   # day of week
s.dt.is_leap_year  # is it a leap year?
```

```
datetime - datetime = interval
datetime + interval = datetime
datetime - interval = datetime
```

In other words, given two datetime objects, we can get an interval object representing the time between them. For example, given a birth date and a death date, we can calculate the length of someone’s life. And given a datetime and an interval, we can get the datetime on the other side of that interval. For example, given a meeting start time and its length, we can find out when it ends—or similarly, if given a meeting end time and its length, we can calculate when it started.

To create a timedelta object or series, we can also call pd.to_timedelta much as we can call pd.to_timestamp. The function’s argument is typically a string or series of strings, each describing a time span, such as '1 hour' or '2 days'.


# Exercise 39: 
1) Load taxi data from July 2019 into a data frame, using only the columns tpep_ pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, and total_amount, 
    - making sure to load tpep_pickup_datetime and tpep_ dropoff_datetime as datetime columns.

2) Create a new column, trip_time, containing the amount of time each taxi ride took as a timedelta.

3) Determine the number and percentage of rides that took less than 1 minute.

4) Determine the average fare paid by people taking these short trips.

5) Determine the number and percentage of rides that took more than 10 hours.

6) Create a new column, trip_time_group, in which the values are short (< 10 minutes), medium (≥ between 10 minutes and 1 hour), and long (> 1 hour).

```
df['trip_time_group'] = (
    pd.cut(
           df['trip_time'],
           bins=[pd.to_timedelta(arg)
                 for arg in ['0 seconds',
                             '10 minutes',
                             '1 hour',
                             '100 hours']],
          labels=['short', 'medium', 'long'])
)
```

to create a new column that based on certain conditions to group them asdf
7) Determine the proportion of rides in each group.

8) For each value in trip_time_group, determine the average number of passengers.