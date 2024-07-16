-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 –7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 –9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL


-- 3) Listado de las solicitudes consignando razon social, direccion y e_mail de la
-- empresa, descripcion del cargo solicitado y años de experiencia solicitados, ordenado por
-- fecha de solicitud y descripción de cargo.asdasdasdsada dfsfsd fsdf sdfsdf sdf sdf 
SELECT razon_social, direccion, e_mail, desc_cargo, anios_experiencia FROM 
empresas E INNER JOIN solicitudes_empresas SE ON E.cuit=SE.cuit
INNER JOIN cargos CA ON SE.cod_cargo=CA.cod_cargo
ORDER BY fecha_solicitud, desc_cargo;

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

-- 8) Mostrar los antecedentes de cada postulante: 
SELECT CONCAT(nombre, apellido) as "Postulante", desc_cargo as "Cargo" FROM
personas P INNER JOIN antecedentes A ON P.dni=A.dni
INNER JOIN cargos C ON A.cod_cargo=C.cod_cargo;

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
SELECT E.cuit, razon_social, desc_cargo, PER.dni, apellido, nombre FROM 
empresas E INNER JOIN solicitudes_empresas SE ON E.cuit=SE.cuit
INNER JOIN cargos CA ON SE.cod_cargo=CA.cod_cargo
LEFT JOIN contratos CON ON SE.cuit=CON.cuit and SE.cod_cargo=CON.cod_cargo and SE.fecha_solicitud=CON.fecha_solicitud
LEFT JOIN personas PER ON CON.dni=PER.dni;

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.
SELECT E.cuit, razon_social, CA.desc_cargo FROM 
solicitudes_empresas SE 
INNER JOIN empresas E ON E.cuit=SE.cuit
INNER JOIN cargos CA ON SE.cod_cargo=CA.cod_cargo
LEFT JOIN  contratos C ON C.cuit=SE.cuit and C.cod_cargo=SE.cod_cargo
WHERE nro_contrato IS NULL;


-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como
-- antecedente) por alguna persona indicar nombre y apellido de la persona y empresa donde
-- lo ocupó.

-- 14) Indicar todos los instructores que tengan un supervisor.
select INS.cuil as "Cuil instructor", INS.nombre as "Nombre instructor", 
INS.apellido as "Apellido instructor",
SUP.cuil as "Cuil supervisor",  INS.cuil_supervisor  as "Cuil supervisor",
SUP.nombre as "Nombre supervisor", SUP.apellido as "Apellido supervisor"
from afatse.instructores INS INNER JOIN afatse.instructores SUP
on INS.cuil_supervisor=SUP.cuil WHERE INS.cuil_supervisor is not null order by INS.cuil;

-- 15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
-- campos en blanco
select INS.cuil as "Cuil instructor", INS.nombre as "Nombre instructor", 
INS.apellido as "Apellido instructor", ifnull(SUP.cuil, "") as "Cuil supervisor",
ifnull(SUP.nombre, "") as "Nombre supervisor", ifnull(SUP.apellido, "") as "Apellido supervisor"
from afatse.instructores INS LEFT JOIN afatse.instructores SUP
on INS.cuil_supervisor=SUP.cuil  order by INS.cuil;

-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
select SUP.cuil, SUP.nombre, SUP.apellido, INS.nombre, INS.apellido, EVAL.nom_plan,
EVAL.nro_curso, A.nombre, A.apellido, EVAL.nro_examen, EVAL.fecha_evaluacion, EVAL.nota from 
afatse.instructores INS inner join afatse.instructores SUP on INS.cuil_supervisor=SUP.cuil
inner join afatse.evaluaciones EVAL ON INS.cuil=EVAL.cuil
INNER JOIN afatse.alumnos A ON EVAL.dni=A.dni
where YEAR(EVAL.fecha_evaluacion) = 2014
# EVAL.fecha_evaluacion between "2014-01-01" and "2014-12-31"
order by SUP.nombre ASC, SUP.apellido ASC, EVAL.fecha_evaluacion DESC;
