WITH CSATData AS (
    SELECT 
        MONTH(CSAT_ans.flt_ctc_created_at) AS month,
        COUNT(CSAT_ans.ticket_id) AS total_responses, 
        COUNT(CASE WHEN CSAT_ans.CSAT IN (4, 5) THEN 1 END) AS positive_responses
    FROM 
        CSAT_ans
    GROUP BY 
        MONTH(CSAT_ans.flt_ctc_created_at)
)
SELECT 
    month,
    CAST(positive_responses AS DECIMAL(10, 2)) / total_responses * 100 AS csat_percentage,
    CASE 
        WHEN LAG(CAST(positive_responses AS DECIMAL(10, 2)) / total_responses * 100) OVER (ORDER BY month) = 0 THEN NULL
        ELSE (CAST(positive_responses AS DECIMAL(10, 2)) / total_responses * 100 - 
              LAG(CAST(positive_responses AS DECIMAL(10, 2)) / total_responses * 100) OVER (ORDER BY month)) / 
             LAG(CAST(positive_responses AS DECIMAL(10, 2)) / total_responses * 100) OVER (ORDER BY month) * 100
    END AS delta_percentual
FROM 
    CSATData
ORDER BY 
    month;

