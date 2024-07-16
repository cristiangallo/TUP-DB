-- PRACTICA SQL V 2024
-- Práctica Nº 1: Sentencia SELECT
-- Practica en Clase: 1 – 3 – 4 – 6 – 7 – 11 – 15
-- Práctica Complementaria: 2 – 5 – 8 – 9 – 10 – 12 – 14
-- BASE DE DATOS: AGENCIA_PERSONAL

use agencia_personal;

-- 1) Mostrar la estructura de la tabla Empresas. Seleccionar toda la información de la misma.
use information_schema;
select * from columns where table_schema='agencia_personal' and table_name="empresas";
select * from agencia_personal.empresas;

-- otra manera
use agencia_personal;
describe `agencia_personal`.`empresas`;
select * from agencia_personal.empresas;

-- 2) Mostrar la estructura de la tabla Personas. Mostrar el apellido y nombre y la fecha de registro en la agencia.
use information_schema;
select * from columns where table_schema='agencia_personal' and table_name="personas";
select apellido, nombre, fecha_registro_agencia "fecha registro" from agencia_personal.personas;

-- 3) Guardar el siguiente query en un archivo de extensión .sql, para luego correrlo. Mostrar los
-- títulos con el formato de columna: Código Descripción y Tipo ordenarlo alfabéticamente
-- por descripción.
select cod_titulo "Código", desc_titulo "Descripción", tipo_titulo "Tipo" from agencia_personal.titulos
order by desc_titulo;

-- 4) Mostrar de la persona con DNI nro. 28675888. El nombre y apellido, fecha de nacimiento,
-- teléfono, y su dirección. Las cabeceras de las columnas serán:
-- Apellido y Nombre(concatenados) Fecha Nac. Teléfono Dirección
select concat(apellido, " ", nombre) as "apellido y nombre", fecha_nacimiento as "Fecha Nac.", telefono,
direccion from agencia_personal.personas where dni=28675888;

-- 5) Mostrar los datos de ej. Anterior, pero para las personas 27890765, 29345777 y 31345778.
-- Ordenadas por fecha de Nacimiento
select concat(apellido, " ", nombre) as "apellido y nombre", fecha_nacimiento as "Fecha Nac.", telefono,
direccion from agencia_personal.personas where dni in (27890765,29345777,31345778) order by fecha_nacimiento asc;

-- 6) Mostrar las personas cuyo apellido empiece con la letra ‘G’.
select * from agencia_personal.personas where apellido like "G%";

-- 7) Mostrar el nombre, apellido de las personas nacidas entre y 1980 y 2000
select nombre, apellido, fecha_nacimiento from agencia_personal.personas where year(fecha_nacimiento) between 1980 and 2000;

-- 8) Mostrar las solicitudes que hayan sido hechas alguna vez ordenados en forma ascendente
-- por fecha de solicitud
select * from agencia_personal.solicitudes_empresas order by fecha_solicitud;

-- 9) Mostrar los antecedentes laborales que aún no hayan terminado su relación laboral
-- ordenados por fecha desde.
select * from agencia_personal.antecedentes where fecha_hasta is null order by fecha_desde asc;

-- 10) Mostrar aquellos antecedentes laborales que finalizaron y cuya fecha hasta no esté entre
-- junio del 2013 a diciembre de 2013, ordenados por número de DNI del empleado.
select * from agencia_personal.antecedentes where fecha_hasta not between "2013-06-01" AND "2013-12-31"
order by dni;

-- 11) Mostrar los contratos cuyo salario sea mayor que 2000 y trabajen en las empresas 30-
-- 10504876-5 o 30-21098732-4. Rotule el encabezado:
-- Nro Contrato DNI Salario CUIT
select nro_contrato "Nro Contrato", dni "DNI", sueldo "SALARIO", cuit "CUIT" 
from agencia_personal.contratos where sueldo > 2000 and cuit in ("30-10504876-5","30-21098732-4");

-- 12) Mostrar los títulos técnicos.
SELECT * FROM agencia_personal.titulos where desc_titulo like "%tecnico%";

-- 13) Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ o el código de cargo sea 6 o 
-- además hayan solicitado aspirantes de sexo femenino.
select * from agencia_personal.solicitudes_empresas where fecha_solicitud > "2013-09-21" or cod_cargo=6 or
sexo='Femenino';

-- 14) Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido terminado.
select * from agencia_personal.contratos where sueldo>2000 and fecha_finalizacion_contrato is null;