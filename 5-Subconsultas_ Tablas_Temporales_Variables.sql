-- Practica Nº 5: Subconsultas, Tablas Temporales y Variables
-- Practica en Clase: 1 – 2 – 3 – 4 –7 – 9 – 10 – 11 – 12 – 16
-- Práctica Complementaria: 5 – 6 – 8 – 13 – 14 – 15 – 17

-- 3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
-- de aquellas cuyo promedio supere al promedio de Tráigame eso.
SELECT EMP.cuit, EMP.razon_social, AVG(COM.importe_comision) as "Promedio comisión" FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
-- where EMP.razon_social like "Tr%igame eso"
GROUP BY EMP.cuit
HAVING AVG(COM.importe_comision) > (SELECT AVG(importe_comision) FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit where EMP.razon_social like "Tr%igame eso");


-- 4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las
-- comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes
-- contrato, año contrato , nro. contrato, nombre y apellido del empleado.
SELECT distinct EMP.razon_social, PER.nombre, PER.apellido, CON.nro_contrato, month(CON.fecha_incorporacion), 
YEAR(CON.fecha_incorporacion), COM.importe_comision FROM `comisiones` COM 
INNER JOIN `contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `empresas` EMP on CON.cuit=EMP.cuit 
INNER JOIN `personas` PER on PER.dni=CON.dni
where COM.fecha_pago is not null and 
COM.importe_comision < (SELECT AVG(importe_comision) FROM `comisiones`);




