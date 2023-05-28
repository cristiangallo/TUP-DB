-- PRACTICA SQL V 2020
-- Práctica Nº 1: Sentencia SELECT
-- Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11 – 15
-- Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14
-- BASE DE DATOS: AGENCIA_PERSONAL



-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 –7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 –9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL

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















