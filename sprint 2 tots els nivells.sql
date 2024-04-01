#tasca 2 
#Realitzaràs diferents scripts per a mostrar la informació que se't sol·licita des de la base de dades que vas usar en l'sprint anterior.
#Nivell 1

#- Exercici 1
#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT  transaction.id , company.country 
FROM transactions.company
INNER JOIN transactions.transaction ON transaction.company_id = company.id
WHERE company.country = "Germany"
;


#- Exercici 2
#Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis
# un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.
#ERROR
Select company_name ,avg(suma_transaccions) AS MITJANA_DE_TOTES_les_transaccions
FROM(
SELECT company.company_name,  sum(transaction.amount) AS suma_transaccions
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
WHERE transaction.declined = 0 
GROUP BY  company.company_name
)
As Subquery
GROUP BY company_name
having (MITJANA_DE_TOTES_les_transaccions) > (SELECT AVG(amount) FROM transactions.transaction)
order by  MITJANA_DE_TOTES_les_transaccions;





#pruebas

SELECT 
    company.company_name,
    SUM(transaction.amount) AS total_amount
FROM 
    transactions.company 
INNER JOIN 
    transactions.transaction ON transaction.company_id = company.id 
GROUP BY 
    company.company_name
HAVING 
    SUM(transaction.amount) > (SELECT AVG(amount) FROM transactions.transaction)
ORDER BY 
    total_amount DESC;
SELECT 
    company_name, 
    AVG(average_sales) AS avg_sales
FROM (
    SELECT 
        company.company_name,  
        AVG(transaction.amount) AS average_sales
    FROM 
        transactions.company 
    INNER JOIN 
        transactions.transaction ON transaction.company_id = company.id 
    WHERE 
        transaction.declined = 0 
    GROUP BY  
        company.company_name
) AS Subquery
GROUP BY 
    company_name
ORDER BY  
    AVG(average_sales);




#3- Exercici 3
#El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, però no recorden el seu nom, 
#només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.

# a) seleccionesm els company_name, i les transaction .id, b)despres fem un inner join entre entre la taula company ("id")i la taula transaction (amb la foreing key "company_id" )
#i despres posem la condició where company_name comença per C ( LIKE 'c%')

SELECT 
    company.company_name,
    transaction.id
FROM 
    transactions.transaction
inner JOIN transactions.company ON transaction.company_id = company.id
WHERE company.company_name LIKE 'c%';


#- Exercici 4
#Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.


SELECT company.company_name,  transaction.id , transaction.declined
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
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



#Exercici 2
#El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.

#prueba
SELECT company.company_name,  transaction.id , max(transaction.amount) as max_amount
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id 
where transaction.declined= 0  
group by company.company_name,  transaction.id
order by max_amount desc
 limit 1 ;
 
SELECT company.company_name,transaction.id,transaction.amount
FROM transactions.transaction
INNER JOIN transactions.company ON transaction.company_id = company.id
WHERE transaction.amount = (SELECT MAX(amount) FROM transactions.transaction)
LIMIT 1;
 
 
 
 
 
 
 
 #prueba
 
 SELECT 
    company.company_name,  
    transaction.id, 
    MAX(transaction.amount) AS max_amount
FROM 
    transactions.company 
INNER JOIN 
    transactions.transaction ON transaction.company_id = company.id 
WHERE 
    transaction.declined = 0  
GROUP BY 
    company.company_name, transaction.id
ORDER BY 
    max_amount DESC
LIMIT 1;
 
 


#Nivell 3
#Exercici 1
#S'estan establint els objectius de l'empresa per al següent trimestre, 
#per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
#Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.


SELECT AVG(amount) 
FROM transaction ;

#CORRECTO
select company.country, avg(transaction.amount) as mitjana_superior
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id
GROUP BY COMPANY.COUNTRY
HAVING AVG(transaction.amount)  > (SELECT AVG(amount) 
FROM transactions.transaction
    );







#correcto
SELECT 
    company.country,
    AVG(transaction.amount) AS mitjana_superior
FROM 
    transactions.company 
INNER JOIN 
    transactions.transaction ON transaction.company_id = company.id
GROUP BY 
    company.country
HAVING 
    AVG(transaction.amount) > (
        SELECT 
            AVG(amount) 
        FROM 
            transactions.transaction
    );



#Exercici 2
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
#per la qual cosa et demanen la informació sobre
# la quantitat de transaccions que realitzen les empreses, 
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
select count(transaction.id) , company.company_name
FROM transactions.company 
INNER JOIN transactions.transaction ON transaction.company_id = company.id
GROUP BY company.company_name
having count(transaction.id) >= 4 or count(transaction.id) < 4 
order by count(transaction.id);