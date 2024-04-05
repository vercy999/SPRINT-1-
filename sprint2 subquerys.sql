#tasca 2 
#Realitzaràs diferents scripts per a mostrar la informació que se't sol·licita des de la base de dades que
# vas usar en l'sprint anterior.
#Nivell 1

#- Exercici 1
#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT  transaction.id , company.country 
FROM transactions.company
INNER JOIN transactions.transaction ON transaction.company_id = company.id
WHERE company.country = "Germany"
;
#CONSUBQUERYS : 
SELECT 
transaction.id,
(SELECT country FROM company WHERE company.id = transaction.company_id) AS country
FROM transaction
WHERE transaction.company_id IN (SELECT id FROM company WHERE country = 'Germany');
    
#- Exercici 2
#Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis
# un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.
SELECT 
transaction.company_id,
transaction.id,
(SELECT AVG(amount) FROM transaction AS t2 WHERE t2.company_id = transaction.company_id AND t2.declined = 0) AS MITJANA_DE_TOTES_les_transaccions
FROM transaction
GROUP BY  transaction.company_id, transaction.id;

#3- Exercici 3
#El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, però no recorden el seu nom, 
#només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.

# a) seleccionesm els company_name, i les transaction .id, b)despres fem un inner join entre entre la taula company ("id")i la taula transaction (amb la foreing key "company_id" )/ 
# o una subquery i despres posem la condició where company_name comença per C ( LIKE 'c%')

SELECT company.company_name, transaction.id
FROM transactions.transaction
inner JOIN transactions.company ON transaction.company_id = company.id
WHERE company.company_name LIKE 'c%';

#con subquerys
select id , company_id ,
(select company_name from company where company.id = transaction.company_id) as company_name 
from transaction 
where company_id IN ( select id from company where company_name LIKE 'c%' );

#- Exercici 4
#Van eliminar del sistema les empreses que no tenen transaccions registrades,
# lliura el llistat d'aquestes empreses.

SELECT company.company_name,  transaction.id , transaction.declined
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
WHERE transaction.id  is  NULL or  declined = 1
;
#con subquerys

SELECT   transaction.id , transaction.declined,
(select company_name from company where company.id = transaction.company_id)
FROM transaction
WHERE transaction.id  is  NULL or  declined = 1
;

#Nivell 2
#Exercici 1
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia Non Institute. 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.


#prueba 
select country 
from company 
where company_name = "Non Institute" ;

SELECT company.company_name,  transaction.id , transaction.declined , company.country
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
 where company.country = (select country 
from company 
where company_name = "Non Institute")
;

#con subquerys
SELECT id ,company_id, declined,
(SELECT id FROM company WHERE company.id = transaction.company_id) AS company_id_in_company_table,
(SELECT country FROM company WHERE company.id = transaction.company_id) AS country 
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE company_name = 'Non Institute') ;

#Exercici 2
#El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.

SELECT company.company_name,  transaction.id, MAX(transaction.amount) AS max_amount
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
WHERE transaction.declined = 0  
GROUP BY company.company_name, transaction.id
ORDER BY max_amount DESC
LIMIT 1;
 
#con  SUBQUERYS 
SELECT id, company_id, SUM(amount) AS suma,
(SELECT id FROM company WHERE company.id = transaction.company_id) AS company_id_in_company_table
FROM transaction
GROUP BY id, company_id
ORDER BY SUM(amount) DESC
LIMIT 1;

#Nivell 3
#Exercici 1
#S'estan establint els objectius de l'empresa per al següent trimestre, 
#per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
#Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.


SELECT AVG(transaction.amount) AS mitjana_superior,
(SELECT company.id FROM company WHERE company.id = transaction.company_id LIMIT 1) AS company_id,
(SELECT company.country FROM company WHERE company.id = transaction.company_id LIMIT 1) AS country
FROM transaction
GROUP BY transaction.company_id
HAVING AVG(transaction.amount) > (SELECT AVG(amount) FROM transaction);


#Exercici 2
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
#per la qual cosa et demanen la informació sobre
# la quantitat de transaccions que realitzen les empreses, 
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions 
#o menys.

SELECT COUNT(id),
(SELECT company_name FROM company WHERE id = transaction.company_id) AS company_name
FROM transaction
GROUP BY company_id
HAVING COUNT(id) >= 4
ORDER BY COUNT(id);
