

-- View to show program enrollment status
CREATE OR REPLACE VIEW program_enrollment_status AS
SELECT 
    rp.program_id,
    rp.program_name,
    rp.capacity,
    COUNT(pp.participation_id) AS currently_enrolled,
    rp.capacity - COUNT(pp.participation_id) AS available_slots,
    ROUND(COUNT(pp.participation_id) * 100.0 / rp.capacity, 1) AS utilization_percent,
    CASE 
        WHEN COUNT(pp.participation_id) >= rp.capacity THEN 'FULL'
        WHEN COUNT(pp.participation_id) >= rp.capacity * 0.8 THEN 'NEAR_CAPACITY'
        ELSE 'AVAILABLE'
    END AS capacity_status
FROM rehab_programs rp
LEFT JOIN program_participation pp ON rp.program_id = pp.program_id
    AND pp.status IN ('ENROLLED', 'IN_PROGRESS')
GROUP BY rp.program_id, rp.program_name, rp.capacity
ORDER BY utilization_percent DESC;

-- Test the view
SELECT * FROM program_enrollment_status WHERE ROWNUM <= 5;