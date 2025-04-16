WITH FRTData AS (
    SELECT 
        MONTH(CX_Contacts.flt_ctc_created_at) AS month,
        AVG(CX_Contacts.flt_ctc_resolution_time_in_seconds) AS avg_frt_seconds
    FROM 
        CX_Contacts
    GROUP BY 
        MONTH(CX_Contacts.flt_ctc_created_at)
)
SELECT 
    month,
    avg_frt_seconds,
  
    CAST(avg_frt_seconds AS DECIMAL(10, 2)) / 60 AS avg_frt_minutes,
    CASE 
        WHEN LAG(avg_frt_seconds) OVER (ORDER BY month) IS NULL THEN NULL
        WHEN LAG(avg_frt_seconds) OVER (ORDER BY month) = 0 THEN NULL
        ELSE 
            (avg_frt_seconds - LAG(avg_frt_seconds) OVER (ORDER BY month)) * 100.0 / LAG(avg_frt_seconds) OVER (ORDER BY month)
    END AS delta_percentual
FROM 
    FRTData
ORDER BY 
    month;

