SELECT 
    CX_Contacts.contact_reason,
    COUNT(CX_Contacts.ticket_id) AS total_contacts,
    CAST(COUNT(CX_Contacts.ticket_id) AS DECIMAL(10, 2)) / 
    (SELECT COUNT(*) FROM CX_Contacts) * 100 AS percentage_of_total
FROM 
    CX_Contacts
GROUP BY 
    CX_Contacts.contact_reason;

