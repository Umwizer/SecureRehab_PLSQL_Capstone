
-- holiday_management.sql
-- Create table to store holidays
CREATE TABLE holiday_management (
    holiday_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    holiday_name VARCHAR2(100) NOT NULL,
    holiday_date DATE NOT NULL,
    description VARCHAR2(500),
    created_by VARCHAR2(50) DEFAULT USER,
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT uk_holiday_date UNIQUE (holiday_date)
);

-- Create index for date-based queries
CREATE INDEX idx_holiday_date ON holiday_management(holiday_date);

-- Insert some test holidays (next month)
INSERT INTO holiday_management (holiday_name, holiday_date, description) VALUES
('New Year''s Day', TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'Public Holiday');
INSERT INTO holiday_management (holiday_name, holiday_date, description) VALUES
('Liberation Day', TO_DATE('2026-01-04', 'YYYY-MM-DD'), 'Rwanda Liberation Day');
INSERT INTO holiday_management (holiday_name, holiday_date, description) VALUES
('Heroes Day', TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'National Heroes Day');
INSERT INTO holiday_management (holiday_name, holiday_date, description) VALUES
('Genocide Memorial', TO_DATE('2026-04-07', 'YYYY-MM-DD'), 'Genocide Against Tutsi Memorial');
COMMIT;