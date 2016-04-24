# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "Creando settings"
  Setting.create!(key: "header_logo", value: "Análisis de la carga de trabajo")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Análisis de la carga de trabajo")

puts "Creando tipos de organizaciones"
  to2 = OrganizationType.create!(acronym: "JD", name: "Junta de Distrito",
                 updated_by: "seed")
  to1 = OrganizationType.create!(acronym: "SGT", name: "Secretaria General Técnica",
                 updated_by: "seed")
  to3 = OrganizationType.create!(acronym: "AG", name: "Áreas de Gobierno",
                 updated_by: "seed")
  to4 = OrganizationType.create!(acronym: "OOAA", name: "Organismos Autónomos",
                 updated_by: "seed")

puts "Creando periodos"
  pdo1 = Period.create!(organization_type_id: to1.id ,name: "1er sem. 2016", description: "Primer semestre de 2016",
                 start_at: "01/01/2016", end_at: "30/06/2016",
                 open_at: "01/04/2016", close_at: "30/04/2016",
                 updated_by: "seed")
  pdo2 = Period.create!(organization_type_id: to2.id ,name: "1er sem. 2016", description: "Primer semestre de 2016",
                 start_at: "01/01/2016", end_at: "30/06/2016",
                 open_at: "01/04/2016", close_at: "30/04/2016",
                 updated_by: "seed")

puts "Creando fuentes"
  s_servicio = Source.create!(name: "Servicio")


puts "Creando datos de Distritos"
puts "  1. Creando datos DEPARTAMENTO DE SERVICIOS JURÍDICOS"
	tu   = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS JURÍDICOS", organization_type_id: to2.id)
puts "     Proceso: TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS"
	n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
  s = 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Contratos menores', updated_by: 'seed')
  t = 1
  tk = Task.create!(order: t, sub_process_id: sp.id, description: "Tarea", updated_by: 'seed' )
  i = 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'n.º de Contratos menores tramitados', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Contratos derivados del acuerdo Marco', updated_by: 'seed')
    tk = Task.create!(order: t, sub_process_id: sp.id, description: "Tarea", updated_by: 'seed' )
  i = i + 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº de contratos Acuerdos Marco', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Expedientes de contratación ( incluye todos los contratos no menores y los no derivados de Acuerdos Marco)', updated_by: 'seed')
    tk = Task.create!(order: t, sub_process_id: sp.id, description: "Tarea", updated_by: 'seed' )
    i = i + 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'n.º de expedientes', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Convenios', updated_by: 'seed')
    tk = Task.create!(order: t, sub_process_id: sp.id, description: "Tarea", updated_by: 'seed' )
    i = i + 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº Convenios tramitados ', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Contratos ', updated_by: 'seed')
    tk = Task.create!(order: t, sub_process_id: sp.id, description: "Tarea", updated_by: 'seed' )
    i = i + 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº de facturas tramitadas', in_out: 'Entrada', amount: 0, updated_by: 'seed')

puts "     Proceso: AUTORIZACIONES Y CONCESIONES"
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
  s = 1

puts "     Proceso: "
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'LICENCIAS', updated_by: 'seed')
  s =  1

puts "     Proceso: "
n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DISCIPLINA', updated_by: 'seed')
  s =  1

puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DENUNCIAS', updated_by: 'seed')
  s =  1

puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'REVISION DE ACTOS Y RESOLUCION DE RECURSOS Y RECLAMACIONES', updated_by: 'seed')

puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'RESPONSABILIDAD PATRIMONIAL', updated_by: 'seed')
puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTIÓN DE INGRESOS NO TRIBUTARIOS', updated_by: 'seed')
puts "     Proceso: "
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTION DE PRECIOS PUBLICOS Y OTROS INGRESOS DE CARÁCTER TRIBUTARIO', updated_by: 'seed')
puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
puts "     Proceso: "
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')


puts "  2. Creando datos DEPARTAMENTO DE SERVICIOS TÉCNICOS"

	tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS TÉCNICOS", organization_type_id: to2)
	  n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	  n = n + 1

	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'LICENCIAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'INSPECCIONES Y PROTECCION DE LA LEGALIDAD', updated_by: 'seed')
	  n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DISCIPLINA', updated_by: 'seed')
    n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DENUNCIAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'RESPONSABILIDAD PATRIMONIAL', updated_by: 'seed')
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN DE PROYECTOS DE OBRA Y MANTENIMIENTO DE EDIFICIOS PÚBLICOS', updated_by: 'seed')
    n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'LIMPIEZA Y MANTENIMIENTO VIA PUBLICA', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')

puts "  3. Creando datos DEPARTAMENTO DE SERVICIOS ECONÓMICOS"
	tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS ECONÓMICOS", organization_type_id: to2)
	  n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUBVENCIONES, PREMIOS Y TRAMITACION DE AYUDAS ECONOMICAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTIÓN DE INGRESOS NO TRIBUTARIOS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTION DE PRECIOS PUBLICOS Y OTROS INGRESOS DE CARÁCTER TRIBUTARIO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
    n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ANTICIPOS DE CAJA FIJA', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
  n = n + 1

puts "  4. Creando datos UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS"
	tu = UnitType.create!(name: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to2)
	  n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'REVISION DE ACTOS Y RESOLUCION DE RECURSOS Y RECLAMACIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTIÓN DE CENTROS Y ACTIVIDADES CULTURALES Y SOCIALES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUBVENCIONES, PREMIOS Y TRAMITACION DE AYUDAS ECONOMICAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ASISTENCIA A ÓRGANOS COLEGIADOS', updated_by: 'seed')

puts "  5. Creando datos SECCIÓN DE EDUCACIÓN"
	tu = UnitType.create!(name: "SECCIÓN DE EDUCACIÓN", organization_type_id: to2)
	n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ESCOLARIZACIÓN Y ACTIVIDADES COMPLEMENTARIAS A LA EDUCACION', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUBVENCIONES, PREMIOS Y TRAMITACION DE AYUDAS ECONOMICAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')

puts "  6. Creando datos DEPARTAMENTO DE SERVICIOS SOCIALES"
	tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to2)
	n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTIÓN DE CENTROS Y ACTIVIDADES CULTURALES Y SOCIALES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUBVENCIONES, PREMIOS Y TRAMITACION DE AYUDAS ECONOMICAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ASISTENCIA A ÓRGANOS COLEGIADOS', updated_by: 'seed')

puts "  7. Creando datos DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO"
	tu = UnitType.create!(name: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to2)
	  n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'LICENCIAS', updated_by: 'seed')
n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'INSPECCIONES Y PROTECCION DE LA LEGALIDAD', updated_by: 'seed')
  n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DISCIPLINA', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DENUNCIAS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')

puts "  8. Creando datos SECRETARÍA DEL DISTRITO"
	tu = UnitType.create!(name: "SECRETARÍA DEL DISTRITO", organization_type_id: to2)
	n = 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ASISTENCIA A ÓRGANOS COLEGIADOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'FE PÚBLICA', updated_by: 'seed')
  n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'CONTROL JURÍDICO-ADMINISTRATIVO', updated_by: 'seed')
  n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'JEFATURA y GESTIÓN DE PERSONAL', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ARCHIVO Y SERVICIOS GENERALES', updated_by: 'seed')

puts "Creando datos SGTs "
  tu = UnitType.create!(name: "SECRETARÍA GENERAL TÉCNICA", organization_type_id: to1)
  n = 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'RÉGIMEN JURÍDICO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'RÉGIMEN INTERIOR', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'GESTIÓN PRESUPUESTARIA', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'RECURSOS HUMANOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'GESTIÓN DE FONDOS DOCUMENTALES', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'REGISTRO Y ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'GASTOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'CONTRATACIÓN', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'GESTIÓN ECONÓMICA', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'PATRIMONIO', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'GESTIÓN DE PROCEDIMIENTOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'TRANSPARENCIA', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'RELAMACIONES Y RECURSOS', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo1.id, unit_type_id: tu.id, description: 'FE PÚBLICA', updated_by: 'seed')
	n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'SUGERENCIAS RECLAMACIONES', updated_by: 'seed')


