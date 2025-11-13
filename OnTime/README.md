# OnTime-LLM

- start clickhouse-cluster
- start universal mcp.demo.altinity.cloud
- create database
- create ro user and jwt


## prompts

- What is the highest number of hops per day for a single aircraft using the same flight number? 
- What does the itinerary look like?

- Find the maximum hops on a single day
```
SELECT Carrier, TailNum, FlightNum, count(*) AS Hops
FROM default.ontime_ref 
WHERE (FlightDate = toDate('2017-01-15')) AND (DepTime < ArrTime) 
GROUP BY Carrier, TailNum, FlightNum
ORDER BY Hops DESC, Carrier, TailNum, FlightNum 
LIMIT 15
```

- Build up a list of stops 
```
SELECT Carrier, TailNum, FlightNum,
  groupArray(DepTime) as Departures,
  length(Departures) as Hops
FROM default.ontime_ref
WHERE (FlightDate = toDate('2017-01-15')) AND (DepTime < ArrTime)
GROUP BY Carrier, TailNum, FlightNum
ORDER BY Hops DESC, Carrier, TailNum, FlightNum
LIMIT 5
```


