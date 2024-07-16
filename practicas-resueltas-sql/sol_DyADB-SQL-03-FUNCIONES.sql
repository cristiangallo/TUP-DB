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
