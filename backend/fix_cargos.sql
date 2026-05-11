SET NAMES utf8mb4;
UPDATE tecnicos SET cargo = 'Encargado de área' WHERE cargo LIKE '%rea%';
UPDATE tecnicos SET cargo = 'Técnico de sistemas' WHERE cargo LIKE '%sistemas%';
UPDATE tecnicos SET cargo = 'Técnico de verificación' WHERE cargo LIKE '%verificaci%';
UPDATE tecnicos SET cargo = 'Técnico de equipo' WHERE cargo LIKE '%equipo%';
UPDATE tecnicos SET cargo = 'Chofer' WHERE cargo LIKE '%Chofer%';
UPDATE tecnicos SET cargo = 'Podador' WHERE cargo LIKE '%Podador%';
UPDATE tecnicos SET cargo = 'Cargador' WHERE cargo LIKE '%Cargador%';
