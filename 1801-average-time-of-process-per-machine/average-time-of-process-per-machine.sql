# Write your MySQL query statement below
-- select a.machine_id,
-- round(
--     (select avg(a1.timestamp) from Activity a1 where a1.activity_type = 'end' and a1.machine_id = a.machine_id) - 
--     (select avg(a1.timestamp) from Activity a1 where a1.activity_type = 'start' and a1.machine_id = a.machine_id)
-- ,3 )as processing_time
-- from Activity a
-- group by a.machine_id


WITH processDuration AS(
    SELECT machine_id , process_id ,
    MAX(CASE WHEN activity_type = 'END' THEN timestamp 
        ELSE NULL 
    END)  
    - 
    MIN(CASE WHEN activity_type = 'START' THEN timestamp 
        ELSE NULL 
    END)  
    AS DURATION
    FROM Activity 
    GROUP BY machine_id , process_id 
),
/*Here we calculate the average*/
averageTime AS(

    SELECT machine_id, AVG(DURATION) AS 'processing_time'
    FROM processDuration 
    GROUP BY machine_id
)
/*Finally we round up the value*/
SELECT machine_id, ROUND(processing_time, 3) AS 'processing_time'
FROM averageTime