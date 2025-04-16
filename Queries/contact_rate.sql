WITH ContactRates AS (
    SELECT 
        MONTH(CX_Contacts.flt_ctc_created_at) AS month,
        CAST(COUNT(CX_Contacts.ticket_id) AS DECIMAL(10, 2)) / 2000000 * 100 AS contact_rate
    FROM 
        CX_Contacts
    GROUP BY 
        MONTH(CX_Contacts.flt_ctc_created_at)
)
SELECT 
    month,
    contact_rate,
    CASE 
        WHEN LAG(contact_rate) OVER (ORDER BY month) = 0 THEN NULL
        ELSE (contact_rate - LAG(contact_rate) OVER (ORDER BY month)) / LAG(contact_rate) OVER (ORDER BY month) * 100
    END AS delta_percentual
FROM 
    ContactRates
ORDER BY 
    month;


WITH ContactRates AS (
    SELECT 
        MONTH(CX_Contacts.flt_ctc_created_at) AS month,
        CX_Contacts.flt_ctc_channel_opened as channel,
        CAST(COUNT(CX_Contacts.ticket_id) AS DECIMAL(10, 2)) / 2000000 * 100 AS contact_rate
    FROM 
        CX_Contacts
    GROUP BY 
        MONTH(CX_Contacts.flt_ctc_created_at),
        CX_Contacts.flt_ctc_channel_opened
)
SELECT 
    month,
    channel,
    contact_rate,
    CASE 
        WHEN LAG(contact_rate) OVER (PARTITION BY channel ORDER BY month) = 0 THEN NULL
        ELSE (contact_rate - LAG(contact_rate) OVER (PARTITION BY channel ORDER BY month)) / LAG(contact_rate) OVER (PARTITION BY channel ORDER BY month) * 100
    END AS delta_percentual
FROM 
    ContactRates
ORDER BY 
    channel, month;

