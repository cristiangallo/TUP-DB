-- Practica Nº 4: GROUP BY - HAVING
-- Practica en Clase: 1 – 2 – 4 –8 – 9 – 13 – 14 – 15
-- Práctica Complementaria: 3 – 5 – 6 –7 – 10 – 11 – 12
-- BASE DE DATOS: AGENCIA_PERSONAL

-- 1) Mostrar las comisiones pagadas por la empresa Tráigame eso
SELECT E.cuit, E.razon_social, sum(COM.importe_comision) as "comisiones pagadas"
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN solicitudes_empresas SE ON CON.cuit=SE.cuit
INNER JOIN empresas E ON SE.cuit=E.cuit
where COM.fecha_pago IS NOT NULL and CON.cuit = "30-21008765-5";

-- 2) Ídem 1) pero para todas las empresas.
SELECT E.cuit, E.razon_social, sum(COM.importe_comision) as "comisiones pagadas"
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN solicitudes_empresas SE ON CON.cuit=SE.cuit
INNER JOIN empresas E ON SE.cuit=E.cuit
where COM.fecha_pago IS NOT NULL group by E.cuit;

-- 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
-- evaluaciones de entrevistas, por tipo de evaluación y entrevistador. Ordenar por promedio
-- en forma ascendente y luego por desviación estándar en forma descendente.
SELECT E.nombre_entrevistador, EVAL.cod_evaluacion, AVG(EE.resultado), STDDEV(EE.resultado), VARIANCE(EE.resultado) 
FROM entrevistas E INNER JOIN entrevistas_evaluaciones EE on E.nro_entrevista=EE.nro_entrevista
INNER JOIN evaluaciones EVAL on EE.cod_evaluacion=EVAL.cod_evaluacion
GROUP BY EE.cod_evaluacion, E.nombre_entrevistador 
ORDER BY 3, 5 DESC;

-- 4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
-- de evaluación.
SELECT E.nombre_entrevistador, EVAL.cod_evaluacion, AVG(EE.resultado), STDDEV(EE.resultado), VARIANCE(EE.resultado) 
FROM entrevistas E INNER JOIN entrevistas_evaluaciones EE on E.nro_entrevista=EE.nro_entrevista
INNER JOIN evaluaciones EVAL on EE.cod_evaluacion=EVAL.cod_evaluacion
WHERE E.nombre_entrevistador = 'Angelica Doria'
GROUP BY EE.cod_evaluacion, E.nombre_entrevistador 
HAVING AVG(EE.resultado) > 71
ORDER BY EVAL.cod_evaluacion;

-- 5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014.
SELECT E.nombre_entrevistador, sum(1) as "cantidad de entrevistas", count(*) as "cantidad de entrevistas"
FROM entrevistas E 
WHERE MONTH(E.fecha_entrevista) = 10 and YEAR(E.fecha_entrevista) = 2014
GROUP BY E.nombre_entrevistador;

-- 6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
-- Ordenado por cantidad de entrevistas.
SELECT E.nombre_entrevistador, EVAL.cod_evaluacion, count(*) as cantidad, 
AVG(EE.resultado), STDDEV(EE.resultado), VARIANCE(EE.resultado) 
FROM entrevistas E INNER JOIN entrevistas_evaluaciones EE on E.nro_entrevista=EE.nro_entrevista
INNER JOIN evaluaciones EVAL on EE.cod_evaluacion=EVAL.cod_evaluacion
-- WHERE E.nombre_entrevistador = 'Angelica Doria'
GROUP BY EE.cod_evaluacion, E.nombre_entrevistador 
HAVING AVG(EE.resultado) > 71
ORDER BY 3;

-- 7) Ídem 6) para aquellos cuya cantidad de entrevistas por código de evaluación
-- sea mayor que 1. Ordenado por nombre en forma descendente y por código de
-- evaluación en forma ascendente
SELECT E.nombre_entrevistador, EVAL.cod_evaluacion, count(*) as cantidad, 
AVG(EE.resultado), STDDEV(EE.resultado)
FROM entrevistas E INNER JOIN entrevistas_evaluaciones EE on E.nro_entrevista=EE.nro_entrevista
INNER JOIN evaluaciones EVAL on EE.cod_evaluacion=EVAL.cod_evaluacion
-- WHERE E.nombre_entrevistador = 'Angelica Doria'
GROUP BY EE.cod_evaluacion, E.nombre_entrevistador 
HAVING count(*) > 1
ORDER BY EVAL.cod_evaluacion;

-- 8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
-- cantidad a pagadas.
SELECT CON.nro_contrato, count(*) as total, count(IFNULL(COM.fecha_pago, NULL)) as pagadas, 
count(*) - count(IFNULL(COM.fecha_pago, NULL)) as "a pagar"
FROM contratos CON INNER JOIN comisiones COM on CON.nro_contrato=COM.nro_contrato
GROUP BY CON.nro_contrato;

-- 9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
-- el % de impagas.
SELECT CON.nro_contrato, count(*) as total, (count(IFNULL(COM.fecha_pago, NULL))) /count(*) * 100 as pagadas, 
(count(*) - count(IFNULL(COM.fecha_pago, NULL))) / count(*) * 100 as "a pagar"
FROM contratos CON INNER JOIN comisiones COM on CON.nro_contrato=COM.nro_contrato
GROUP BY CON.nro_contrato;

-- 10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
-- diferencia respecto al total de solicitudes.


-- 11) Cantidad de solicitudes por empresas.
SELECT E.cuit, E.razon_social, count(*) as "cant. solicitudes" 
from solicitudes_empresas SE INNER JOIN empresas E on SE.cuit=E.cuit 
GROUP BY SE.cuit;

-- 12) Cantidad de solicitudes por empresas y cargos.
SELECT E.cuit, E.razon_social, SE.cod_cargo, count(*) as "cant. solicitudes" 
from solicitudes_empresas SE INNER JOIN empresas E on SE.cuit=E.cuit 
INNER JOIN cargos C ON SE.cod_cargo=C.cod_cargo
GROUP BY SE.cuit, SE.cod_cargo;

-- LEFT/RIGHT JOIN
-- 13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
-- que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
-- mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.


-- 14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
-- forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
-- 0. Agregar algún cargo que nunca haya sido solicitado


-- 15) Indicar los cargos que hayan sido solicitados menos de 2 veces
SELECT C.cod_cargo, C.desc_cargo, count(*) as "cant. solicitudes" 
from cargos C
LEFT JOIN solicitudes_empresas SE ON SE.cod_cargo=C.cod_cargo=SE.cod_cargo
GROUP BY C.cod_cargo;
