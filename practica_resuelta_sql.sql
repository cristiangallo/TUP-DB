-- PRACTICA SQL V 2020
-- Práctica Nº 1: Sentencia SELECT
-- Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11 – 15
-- Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14
-- BASE DE DATOS: AGENCIA_PERSONAL



-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 –7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 –9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL


-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
-- Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
-- S.A
SELECT DISTINCT CONCAT(P.apellido, " ", P.nombre, " ", 
IFNULL(CONCAT("tiene como referencia a ", A.persona_contacto), CONCAT("no tiene referencias")), 
" cuando trabajó en ", UPPER(E.razon_social)) as texto
from personas P INNER JOIN antecedentes A ON P.dni=A.dni
INNER JOIN empresas E ON A.cuit=E.cuit
WHERE A.persona_contacto IN ("Armando Esteban Quito", "Felipe Rojas") or A.persona_contacto IS NULL;

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
-- ascendente por empresa y descendente por cargo:
SELECT EMPRE.razon_social, CAR.desc_cargo, EVAL.desc_evaluacion, EE.resultado 
from evaluaciones EVAL
INNER JOIN entrevistas_evaluaciones EE ON EVAL.cod_evaluacion=EE.cod_evaluacion
INNER JOIN entrevistas ENTRE ON EE.nro_entrevista=ENTRE.nro_entrevista
INNER JOIN solicitudes_empresas SOL ON SOL.cuit=ENTRE.cuit
INNER JOIN empresas EMPRE ON SOL.cuit=EMPRE.cuit
INNER JOIN cargos CAR ON CAR.cod_cargo=ENTRE.cod_cargo 	
ORDER BY EMPRE.razon_social ASC, CAR.desc_cargo DESC; 

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
-- y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
-- leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.
SELECT EMP.cuit, EMP.razon_social, IFNULL(SOL.fecha_solicitud, "Sin Solicitudes"), IFNULL(CAR.desc_cargo, "Sin Solicitudes")
from empresas EMP 
LEFT JOIN solicitudes_empresas SOL on EMP.cuit=SOL.cuit
LEFT JOIN cargos CAR ON SOL.cod_cargo=CAR.cod_cargo;

-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
-- y si se hubiese realizado un contrato los datos de la(s) persona(s).

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.

-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como
-- antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
-- lo ocupó.

-- 14) Indicar todos los instructores que tengan un supervisor.

-- 15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
-- campos en blanco

-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.


-- Práctica Nº 3: Funciones de presentación de datos
-- Practica Complementaria: 1 – 2 – 3 – 4 – 5
-- BASE DE DATOS: AGENCIA_PERSONAL

-- 1) Para aquellos contratos que no hayan terminado calcular la fecha de caducidad
-- como la fecha de solicitud más 30 días (no actualizar la base de datos). Función ADDDATE
SELECT nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, 
IFNULL(fecha_caducidad, ADDDATE(fecha_solicitud, INTERVAL 30 DAY)) as "Fecha caducidad"
FROM contratos WHERE fecha_caducidad IS NULL;

-- 2) Mostrar los contratos. Indicar nombre y apellido de la persona, razón social de la
-- empresa fecha de inicio del contrato y fecha de caducidad del contrato. Si la fecha no ha
-- terminado mostrar “Contrato Vigente”. Función IFNULL
SELECT DISTINCT C.nro_contrato, E.razon_social, P.apellido, P.nombre, C.fecha_incorporacion, 
IFNULL(C.fecha_finalizacion_contrato, "Contrato vigente")
FROM contratos C inner join personas P on C.dni=P.dni
inner join solicitudes_empresas SE on C.cuit=SE.cuit
inner join empresas E on E.cuit=SE.cuit ORDER BY C.nro_contrato;

-- 3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
-- cantidad de días que finalizaron antes de tiempo. Función DATEDIFF
SELECT C.nro_contrato, C.fecha_incorporacion, C.fecha_finalizacion_contrato, C.fecha_caducidad,
C.sueldo, C.porcentaje_comision, C.dni, C.cuit, C.cod_cargo, C.fecha_solicitud,
datediff(C.fecha_finalizacion_contrato, C.fecha_caducidad)
from contratos C WHERE C.fecha_caducidad < C.fecha_finalizacion_contrato;

-- 4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
-- empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
-- calcula como la fecha actual más dos meses. Función ADDDATE con INTERVAL
SELECT DISTINCT E.cuit, E.razon_social, E.direccion, COM.anio_contrato, COM.mes_contrato, COM.importe_comision,
ADDDATE(CURDATE(), interval 2 MONTH) as fecha_vencimiento
FROM comisiones COM INNER JOIN contratos CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN solicitudes_empresas SE ON CON.cuit=SE.cuit
inner join empresas E on SE.cuit=E.cuit
where COM.fecha_pago is null;

-- 5) Mostrar en qué día mes y año nacieron las personas (mostrarlos en columnas
-- separadas) y sus nombres y apellidos concatenados. Funciones DAY, YEAR, MONTH y CONCAT
SELECT concat(nombre, " ", apellido), fecha_nacimiento, DAY(fecha_nacimiento) as día, 
MONTH(fecha_nacimiento) as mes, YEAR(fecha_nacimiento) as año
FROM personas P;


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
