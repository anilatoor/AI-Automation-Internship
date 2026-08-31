-- ============================================================
-- Task 1: Build a Lead Management Database
-- ============================================================

--1. Creating leads table
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(30),
    company VARCHAR(100),
    source VARCHAR(50),
    lead_score INT,
    status VARCHAR(30) DEFAULT 'New',
    created_at TIMESTAMP DEFAULT NOW()
);

--2. Populating the leads table with 10 leads
INSERT INTO leads (name, email, phone, company, source, lead_score, status) VALUES
('Ahmed Khan',   'ahmed@abc.com',   '03001234567', 'ABC Corp',    'Facebook', 85, 'Qualified'),
('Sara Ali',     'sara@xyz.com',    '03007654321', 'XYZ Ltd',     'LinkedIn', 72, 'Contacted'),
('John Smith',   'john@mail.com',   '03111111111', 'Smith Co',    'Website',  60, 'New'),
('Fatima Noor',  'fatima@noor.com', '03222222222', 'Noor Trade',  'Google',   90, 'Converted'),
('Bilal Raza',   'bilal@raza.com',  '03333333333', 'Raza Inc',    'Referral', 45, 'Lost'),
('Ayesha Malik', 'ayesha@m.com',    '03444444444', 'Malik Group', 'Facebook', 78, 'Qualified'),
('David Lee',    'david@lee.com',   '03555555555', 'Lee LLC',     'LinkedIn', 55, 'New'),
('Zainab Omar',  'zainab@o.com',    '03666666666', 'Omar Co',     'Website',  88, 'Qualified'),
('Hassan Tariq', 'hassan@t.com',    '03777777777', 'Tariq Ltd',   'Google',   30, 'Lost'),
('Maria Garcia', 'maria@g.com',     '03888888888', 'Garcia SA',   'Referral', 95, 'Converted');

--3. Display all leads
SELECT * FROM leads;

--4.Display only qualified leads
SELECT * FROM leads WHERE status = 'Qualified';

--5. Display leads with score greater than 70
SELECT * FROM leads WHERE lead_score > 70;

--6. Update one lead's status
UPDATE leads SET status = 'Converted' WHERE id = 2;

--7. Delete one lead
DELETE FROM leads WHERE id = 9;
SELECT * FROM leads

--8. Top 5 leads by lead_score
SELECT * FROM leads ORDER BY lead_score DESC LIMIT 5;
