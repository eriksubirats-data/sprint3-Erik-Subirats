USE transactions;
##############NIVELL 1######################################################################################################################################################################################
##EXERCICI 1-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Creo la taula 'credit_card'
CREATE TABLE  IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(20),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    expiring_date VARCHAR(8)
);

#Inserto totes les dades a la taula 'credit_card' d'aquesta forma:
# INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) VALUES ('CcS-9581', 'XX915670516405388124398147', '2624305470167630', '4336', '926', '06/29/25');

#Afegeixo la FK credit_card_id a la taula 'transaction'
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id); 

##EXERCICI 2-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Canvio el número d'IBAN de la targeta de crèdit 'CcU-2938'
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

#Comprovo el canvi
SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';

##EXERCICI 3-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Intento ingressar les dades (ERROR: no existeixen les FK 'credit_card_id' ni 'company_id' a les seves taules)
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude,  amount, declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

#Comprovo si les FK realment no hi són a les seves taules: 
SELECT *
FROM credit_card
WHERE id = 'CcU-9999';

SELECT *
FROM company
WHERE id = 'b-9999';

#Afegeixo les dades a les taules 'credit_card' i 'company'
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) VALUES ('CcU-9999', NULL, NULL, NULL, NULL, NULL);
INSERT INTO company (id, company_name, phone, email, country, website) VALUES ('b-9999', NULL, NULL, NULL, NULL, NULL);

#Inserto les dades de nou (ARA SENSE ERROR)
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude,  amount, declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

##EXERCICI 4-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Elimino la columna 'pan' de 'credit_card'
ALTER TABLE credit_card
DROP COLUMN pan;

#Comprovo que ja no existeix la columna 'pan'
DESCRIBE credit_card;

##############NIVELL 2######################################################################################################################################################################################
##EXERCICI 1-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Elimino el registre '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD' de la taula 'transaction'
DELETE FROM transaction 
WHERE id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

#Comprovo que ja no existeix
SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

##EXERCICI 2-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Creo la vista 'VistaMarketing'
CREATE VIEW VistaMarketing AS
SELECT 
	c.company_name, 
    c.phone, 
    c.country, 
    ROUND(AVG(t.amount), 2) AS purchase_avg
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.id, c.company_name;

#Presento la vista amb ordre de major a menor mitjana de compra
SELECT *
FROM VistaMarketing
ORDER BY purchase_avg DESC;

##EXERCICI 3-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Filtre de 'VistaMarketing' on country = 'Germany'
SELECT *
FROM VistaMarketing
WHERE country = 'Germany';

##############NIVELL 3######################################################################################################################################################################################
##EXERCICI 1-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Creo la taula 'data_user'
CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

#Inserto les dades a la taula 'data_user' d'aquesta forma:
# INSERT INTO user (id, name, surname, phone, email, birth_date, country, city, postal_code, address) VALUES (        "151", "Meghan", "Hayden", "0800 746 6747", "arcu.vel@hotmail.ca", "Jul 2, 1980", "United Kingdom", "London", "EC1A 1BB", "Ap #432-4493 Aliquet Rd.");

#1r canvi: eliminar columna 'website' de 'company'
ALTER TABLE company
DROP COLUMN website;

#2n canvi: canvi del VARCHAR(15) a VARCHAR(20) a 'id' de 'credit_card'
ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

#3r canvi: canvi del VARCHAR a INT a 'cvv' de 'credit_card'
ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

#4t canvi: afegir la columna 'fecha_actual' del tipus DATE a 'credit_card'
ALTER TABLE credit_card
ADD fecha_actual DATE;

#5é canvi: canvi de nom de la taula 'user' a 'date_user'
RENAME TABLE user TO data_user;

#6é canvi: canvi del CHAR a INT a 'id' de 'data_user':
ALTER TABLE data_user
MODIFY COLUMN id INT;

#7é canvi: canvi de nom de la columna 'email' a 'personal_email' de 'data_user'
ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

#8é canvi: canvi del VARCHAR(15) a VARCHAR(20) a 'credit_card_id' de 'transaction'
ALTER TABLE transaction
MODIFY credit_card_id VARCHAR(20);

#9é canvi: establir la columna 'user_id' de la taula 'transaction' com a clau forana (FOREIGN KEY) que fa referència a la columna 'id' de la taula 'data_user' (ERROR)
ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES data_user(id);

#Busco l'error
SELECT user_id
FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);

#Afegeixo el registre id = '9999' a la taula 'data_user'
INSERT INTO data_user (id, name, surname, phone, personal_email, birth_date, country, city, postal_code, address) VALUES ('9999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

#Repeteixo ADD FOREIGN KEY
ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES data_user(id);

##EXERCICI 3-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Creació de la vista 'InformeTecnico'
CREATE VIEW InformeTecnico AS
SELECT 
	t.id AS transaction_id, 
    du.name AS user_name,
    du.surname AS user_surname,
    cc.iban AS IBAN, 
	c.company_name
FROM  transaction t 
JOIN data_user du ON t.user_id = du.id
JOIN credit_card cc ON t.credit_card_id = cc.id
JOIN company c ON t.company_id = c.id;

#Mostra dels resultats de la vista
SELECT *
FROM InformeTecnico
ORDER BY transaction_id DESC;