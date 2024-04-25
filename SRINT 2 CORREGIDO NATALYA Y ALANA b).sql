#tasca 2 
#Realitzaràs diferents scripts per a mostrar la informació que se't sol·licita des de la base de dades que
# vas usar en l'sprint anterior.
#Nivell 1

#- Exercici 1
#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT t.id, t.credit_card_id, t.company_id, t.user_id, t.lat, t.longitude, t.timestamp, t.amount, t.declined
FROM transactions.transaction t
WHERE t.company_id IN (SELECT id FROM transactions.company c WHERE c.country = 'Germany');

#- Exercici 2
#Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis
# un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.

SELECT c.id, c.company_name, c.country FROM transactions.company c
WHERE c.id IN (SELECT t.company_id FROM transactions.transaction t WHERE t.amount > (SELECT AVG(amount) FROM transactions.transaction )
);
#3- Exercici 3
#El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, però no recorden el seu nom, 
#només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.

# a) seleccionesm els company_name, i les transaction .id, b)despres fem un inner join entre entre la taula company ("id")i la taula transaction (amb la foreing key "company_id" )/ 
# o una subquery i despres posem la condició where company_name comença per C ( LIKE 'c%')

SELECT t.id, t.company_id, 
(SELECT c.company_name FROM transactions.company c WHERE c.id = t.company_id) AS company_name 
FROM transactions.transaction t 
WHERE t.company_id IN (SELECT c.id FROM transactions.company c WHERE c.company_name LIKE 'c%');

#- Exercici 4
#Van eliminar del sistema les empreses que no tenen transaccions registrades,
# lliura el llistat d'aquestes empreses.

SELECT id AS company_id, company_name, country FROM transactions.company c
WHERE NOT EXISTS (SELECT 1 FROM transactions.transaction t WHERE t.company_id = c.id
);
#Nivell 2
#Exercici 1
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia Non Institute. 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

SELECT t.id As transacció , t.company_id, t.declined, t.amount , 
(SELECT c.company_name FROM transactions.company c WHERE c.id = t.company_id) AS company_name, t.company_id AS company_id
FROM transactions.transaction t
WHERE (SELECT c.country FROM transactions.company c WHERE c.id = t.company_id) =
      (SELECT c.country FROM transactions.company c  WHERE c.company_name = 'Non Institute');
      
      
 
#Exercici 2
#El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.     

SELECT  t.company_id, max(t.amount ), 
 (SELECT id FROM transactions.company c  WHERE c.id = t.company_id ) as company_id_in_company_table
 FROM transactions.transaction t 
 GROUP BY  t.company_id 
 ORDER BY MAX(t.amount) desc
 LIMIT 1 ; 
 
 #Nivell 3
#Exercici 1
#S'estan establint els objectius de l'empresa per al següent trimestre, 
#per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
#Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.
SELECT country, ROUND(AVG(amount), 2) AS promedio_por_pais
FROM 
(SELECT t.amount, (SELECT country FROM company WHERE id = t.company_id) AS country
FROM transaction t) AS transacciones_por_pais
GROUP BY country
HAVING ROUND(AVG(amount), 2) > (SELECT ROUND(AVG(amount), 2) FROM transaction);
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


