#tasca 2 
#Realitzaràs diferents scripts per a mostrar la informació que se't sol·licita des de la base de dades que
# vas usar en l'sprint anterior.
#Nivell 1

#- Exercici 1
#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT t.id, t.credit_card_id, t.company_id, t.user_id, t.lat, t.longitude, t.timestamp, t.amount, t.declined
FROM transactions.transaction t
WHERE t.company_id IN (SELECT id FROM transactions.company WHERE country = 'Germany');

#- Exercici 2
#Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis
# un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.

SELECT c.id AS company_id, c.company_name, c.country
FROM transactions.company c
WHERE c.id IN (SELECT company_id FROM transactions.transaction WHERE amount > (SELECT AVG(amount)FROM transactions.transaction));

#3- Exercici 3
#El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, però no recorden el seu nom, 
#només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.

# a) seleccionesm els company_name, i les transaction .id, b)despres fem un inner join entre entre la taula company ("id")i la taula transaction (amb la foreing key "company_id" )/ 
# o una subquery i despres posem la condició where company_name comença per C ( LIKE 'c%')

select id , company_id ,
(select company_name from company where company.id = transaction.company_id) as company_name 
from transaction 
where company_id IN ( select id from company where company_name LIKE 'c%' );

#- Exercici 4
#Van eliminar del sistema les empreses que no tenen transaccions registrades,
# lliura el llistat d'aquestes empreses.


SELECT id AS company_id,company_name,country
FROM transactions.company
WHERE id NOT IN (SELECT DISTINCT company_id FROM transactions.transaction );

#Nivell 2
#Exercici 1
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia Non Institute. 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

SELECT id, company_id, declined
FROM transaction 
WHERE company_id IN (SELECT id FROM company WHERE country = (SELECT country FROM company WHERE company_name = 'Non Institute'));


#Exercici 2
#El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.

SELECT company.company_name,  transaction.id, MAX(transaction.amount) AS max_amount
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
WHERE transaction.declined = 0  
GROUP BY company.company_name, transaction.id
ORDER BY max_amount DESC
LIMIT 1;
 
#Nivell 3
#Exercici 1
#S'estan establint els objectius de l'empresa per al següent trimestre, 
#per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
#Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.

SELECT country, AVG(amount) AS promedio_por_pais
FROM 
(SELECT t.amount,(SELECT country FROM company WHERE id = t.company_id) AS country
FROM transaction t) AS transacciones_por_pais
GROUP BY country
HAVING AVG(amount) > (SELECT AVG(amount) FROM transaction);



#Exercici 2
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
#per la qual cosa et demanen la informació sobre
# la quantitat de transaccions que realitzen les empreses, 
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions 
#o menys.

SELECT 
CASE 
	WHEN COUNT(id) > 4 THEN 'Más de 4 transacciones'
	ELSE 'Menos de 4 transacciones'
    END AS transaction_category,
(SELECT company_name FROM company WHERE id = transaction.company_id) AS company_name,COUNT(id) AS transaction_count , company_id
FROM transaction
GROUP BY company_id
ORDER BY COUNT(id);