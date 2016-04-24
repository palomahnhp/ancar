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
  Setting.create!(key: "app_name", value: "Análisis de la seed de trabajo")

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
	mp = MainProcess.create!(order: #{n=n+1}, period_id: pdo2.id, unit_type_id: tu.id, description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
  s = 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Contratos menores', updated_by: 'seed')
  t = 1
  tk = Task.create!(order: t, sub_process_id: sp, description: "Tarea", updated_by: 'seed' )
  i = 1
  id = Indicator.create!(order: i, task_id: tk.id, description: 'n.º de Contratos menores tramitados', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Contratos derivados del acuerdo Marco', updated_by: 'seed')
  id = Indicator.create!(order: i, task_id: tk.id, description: 'n.º de expedientes', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Expedientes de contratación ( incluye todos los contratos no menores y los no derivados de Acuerdos Marco)', updated_by: 'seed')
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº de contratos Acuerdos Marco', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Convenios', updated_by: 'seed')
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº Convenios tramitados', in_out: 'Entrada', amount: 0, updated_by: 'seed')
  s = s + 1
  sp = SubProcess.create!(order: s, main_process_id: mp.id,  description: 'Compras centralizadas', updated_by: 'seed')
  id = Indicator.create!(order: i, task_id: tk.id, description: 'nº de facturas tramitadas', in_out: 'Entrada', amount: 0, updated_by: 'seed')

  n = n + 1
	mp = MainProcess.create!(order: #{n=n+1}, period_id: pdo2.id, unit_type_id: tu.id, description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'LICENCIAS', updated_by: 'seed')
  n = n + 1
  mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DISCIPLINA', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'DENUNCIAS', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'REVISION DE ACTOS Y RESOLUCION DE RECURSOS Y RECLAMACIONES', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'RESPONSABILIDAD PATRIMONIAL', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTIÓN DE INGRESOS NO TRIBUTARIOS', updated_by: 'seed')
  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'GESTION DE PRECIOS PUBLICOS Y OTROS INGRESOS DE CARÁCTER TRIBUTARIO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
	  n = n + 1
	mp = MainProcess.create!(order: n, period_id: pdo2.id, unit_type_id: tu.id, description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
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

puts "Creando subprocesos"
	SubProcess.create!(main_process_id: 1, order:  1, description: 'ASUNTOS JUNTA DE GOBIERNO, PLENONES DEL PLENO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 1, order:  2, description: 'PROYECTOS NORMATIVOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 1, order:  3, description: 'INFORMACIÓN AL PLENO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 1, order:  4, description: 'DOCUMENTACION TRIBUNALES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 1, order:  5, description: 'EJECUCIÓN SENTENCIAS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 1, order:  6, description: 'QUEJAS DEFENSOR DEL PUEBLO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  1, description: 'SEGURIDAD Y CONTROL DE ACCESOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  2, description: 'PREVENCIÓN DE RIESGOS LABORALES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  3, description: 'INSTRUCCIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  4, description: 'ARENDAMIENTO DE EDIFICIOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  5, description: 'ESPACIOS DE TRABAJO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  6, description: 'MOBILIARIO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  7, description: 'MATERIAL', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  8, description: 'TELEFONÍA Y SUMINISTROS INFORMÁTICOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  9, description: 'ESTACIONAMIENTO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  10, description: 'GESTIÓN PERSONAL POSI Y CONDUCTORES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  11, description: 'CONDUCTORES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  12, description: 'POSIS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 2, order:  13, description: 'PODOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 3, order:  1, description: 'PROPUESTA DE PRESUPUESTO ANUAL DE LA SGT', updated_by: 'seed')
	SubProcess.create!(main_process_id: 3, order:  2, description: 'COORDINACIÓN DE LAS PROPUESTAS DE LAS DIRECCIONES GENERALES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 3, order:  3, description: 'EJECUIÓN DEL PRESUPUESTO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 3, order:  4, description: 'MODIFICACIONES PRESUPUESTARIAS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  1, description: 'ESTRUCTURA, RELACIÓN DE PUESTOS DE TRABAJO Y PLANTILLA PRESUPUESTARIA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  2, description: 'PROVISIÓN DE PUESTOS/INCORPORACIÓN DE PERSONAL', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  3, description: 'ELABORACIÓN DE INFORMES/EXPEDICIÓN DE CERTIFICACIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  4, description: 'RETRIBUCIONES/SEGURIDAD SOCIAL', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  5, description: 'GESTIÓN TIEMPO DE TRABAJO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  6, description: 'SITUACIONES ADMINISTRATIVAS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  7, description: 'PERMISOS Y VACACIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  8, description: 'ACREDITACIÓN DE EMPLEADOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  9, description: 'SALUD LABORAL', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  10, description: 'RESPONSABILIDAD DISCIPLINARIA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 4, order:  11, description: 'FORMACION', updated_by: 'seed')
	SubProcess.create!(main_process_id: 5, order:  1, description: 'DOCUMENTACIÓN Y PUBLICACIÓN', updated_by: 'seed')
	SubProcess.create!(main_process_id: 5, order:  2, description: 'PRECIOS Y PUBLICACIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 6, order:  1, description: 'SUGERENCIAS Y RECLAMACIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 6, order:  2, description: 'REGISTRO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 6, order:  3, description: 'FIRMA ELECTRÓNICA A LOS CIUDADANOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 7, order:  1, description: 'GASTOS DE LA SGT', updated_by: 'seed')
	SubProcess.create!(main_process_id: 8, order:  1, description: 'CONTRATACIONES DE LA SGT', updated_by: 'seed')
	SubProcess.create!(main_process_id: 8, order:  2, description: 'EXPEDIENTES DE CONTRACIÓN DEL ÁREA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 9, order:  1, description: 'EXPEDIENTES DE GASTO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 9, order:  2, description: 'ANTICIPOS DE CAJA FIJA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 9, order:  3, description: 'LIBRAMIENTOS A JUSTIFICAR', updated_by: 'seed')
	SubProcess.create!(main_process_id: 10, order:  1, description: 'CATÁLOGO DE BIENES INMUEBLES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 10, order:  2, description: 'INVENTARIO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 10, order:  3, description: 'MANTENIMIENTO DE EDIFICIOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 10, order:  4, description: 'EFCIENCIA ENERGÉTICA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  1, description: 'ARCHIVO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  2, description: 'PROUESTA DECRETOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  3, description: 'DECRETOS PROPUESTOS POR LOS CENTROS DIRECTIVOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  4, description: 'PUBLICACIONES OFICIALES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  5, description: 'CONVENIOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  6, description: 'PETICIONES DE INFORMACIÓN', updated_by: 'seed')
	SubProcess.create!(main_process_id: 11, order:  7, description: 'INICIATIVAS DE PLENOS DE JUNTAS DE DISTRITO', updated_by: 'seed')
	SubProcess.create!(main_process_id: 12, order:  1, description: 'SOLICITUDES DE ACCESO A INFORMACIÓN PÚBLICA', updated_by: 'seed')
	SubProcess.create!(main_process_id: 13, order:  1, description: 'RECURSOS', updated_by: 'seed')
	SubProcess.create!(main_process_id: 14, order:  1, description: 'LIBRO DE RESOLUCIONES', updated_by: 'seed')
	SubProcess.create!(main_process_id: 14, order:  2, description: 'EXPEDICIÓN DE CERTIFICACIONES', updated_by: 'seed')

puts "Creando tareas"
	Task.create!(sub_process_id: 1, order: 1, description: 'Revisión jurídica, preparación de documentación y petición de informes de los asuntos a tratar en la Comisión Preparatoria con carácter previo a su elevación a la Junta de Gobierno', updated_by: 'seed')
	Task.create!(sub_process_id: 1, order: 2, description: 'Revisión jurídica, preparación de documentación y petición de informes de asuntos que el titular del Área de Gobierno eleva para su aprobación a la Junta de Gobierno o al Pleno del Ayuntamiento de Madrid', updated_by: 'seed')
	Task.create!(sub_process_id: 1, order: 3, description: 'Revisión jurídica, preparación de documentación, petición de informes sobre asuntos de competencia de las Comisiones del Pleno y asistencia a las sesiones', updated_by: 'seed')
	Task.create!(sub_process_id: 1, order: 1, description: 'Elaboración de informes sobre asuntos de otras Áreas de Gobierno incluidos en el orden del día de Comisión Preparatoria, Junta de Gobierno o Pleno', updated_by: 'seed')
	Task.create!(sub_process_id: 2, order: 1, description: 'Preparación, revisión y tramitación de proyectos de Ordenanzas y Reglamentos impulsados por el Área de Gobierno: preparación del proyecto inicial, solicitud de informes preceptivos, análisis de observaciones y enmiendas y redacción definitiva', updated_by: 'seed')
	Task.create!(sub_process_id: 2, order: 1, description: 'Redacción de informes sobre proyectos de carácter normativo (Ordenanzas, Reglamentos) impulsados por las restantes Áreas de Gobierno', updated_by: 'seed')
	Task.create!(sub_process_id: 3, order: 1, description: 'Remisión mensual a la Secretaría General del Pleno de la información a que se refiere el artículo 22 del ROP: contratos adjudicados, convenios celebrados, modificaciones presupuestarias y ejecución presupuestaria', updated_by: 'seed')
	Task.create!(sub_process_id: 3, order: 2, description: 'Remisión trimestral a la Secretaría General del Pleno de la información sobre ejecución presupuestaria y de los balances y cuentas de pérdidas y ganancias de las sociedades mercantiles municipales (art.7 Bases de Ejecución del Presupuesto)', updated_by: 'seed')
	Task.create!(sub_process_id: 4, order: 1, description: 'Solicitud expediente', updated_by: 'seed')
	Task.create!(sub_process_id: 4, order: 2, description: 'Envío al juzgado', updated_by: 'seed')
	Task.create!(sub_process_id: 4, order: 3, description: 'Comunicación de sentencia', updated_by: 'seed')
	Task.create!(sub_process_id: 5, order: 1, description: 'Solicitud de financiación', updated_by: 'seed')
	Task.create!(sub_process_id: 5, order: 2, description: 'Actuaciones de ejecución', updated_by: 'seed')
	Task.create!(sub_process_id: 6, order: 1, description: 'Remisión a los órganos directivos competentes para su contestación de las quejas dirigidas por los ciudadanos a la Defensora del Pueblo en materias o servicios competencia del Área de Gobierno', updated_by: 'seed')
	Task.create!(sub_process_id: 6, order: 2, description: 'Revisión de las contestaciones de los órganos directivos', updated_by: 'seed')
	Task.create!(sub_process_id: 6, order: 3, description: 'Remisión de la contestación al Área de Gobierno competente para su traslado a la Defensora del Pueblo', updated_by: 'seed')
	Task.create!(sub_process_id: 7, order: 1, description: 'Revisión de los partes diarios del personal de seguridad de los edificios y gestión de las incidencias', updated_by: 'seed')
	Task.create!(sub_process_id: 7, order: 2, description: 'Tareas de control de los accesos', updated_by: 'seed')
	Task.create!(sub_process_id: 7, order: 1, description: 'Atención a las comunicaciones de altas y bajas de personal y a las solicitudes provisionales  de tarjetas corporativas', updated_by: 'seed')
	Task.create!(sub_process_id: 7, order: 2, description: 'Solicitud de activación de las tarjetas corporativas para la entrada en edificios del Área', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 1, description: 'Revisión periódica de planes de autoprotección y medidas de emergencia implantados', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 2, description: 'Cambios del personal que integra los equipos de emergencia comunicándoselo al Comité de Seguridad y Salud', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 3, description: 'Organización de los cursos de formación del personal del Área en materia de evacuación', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 4, description: 'Organización y seguimiento de los simulacros de evacuación de los edificios', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 5, description: 'Análisis de los informes de la realización del simulacro y adopción de las medidas correspondientes', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 6, description: 'Participación en la elaboración y seguimiento de las evaluaciones de riesgo que realizan los Servicios de Prevención del Ayuntamiento', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 7, description: 'Gestión de la coordinación de actividades empresariales en materia de prevención de riesgos laborales con las empresas adjudicatarias de los contratos gestionados por la S.G.T.', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 8, description: 'Atención de las solicitudes e incidencias en materia de prevención de riesgos laborale', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 9, description: 'Participación en las reuniones de Comité de Seguridad y Salud', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 10, description: 'Gestión del mantenimiento de los botiquines de primeros auxilios ubicados en los edificios', updated_by: 'seed')
	Task.create!(sub_process_id: 8, order: 11, description: 'Solicitud a la Sección de Control de Vectores de las revisiones periódicas de los edificios y comunicación de la aparición de vectores', updated_by: 'seed')
	Task.create!(sub_process_id: 9, order: 10, description: 'Difusión a las Direcciones Generales a través del correo electrónico de  instrucciones o procedimientos en materia de régimen interior que se establecen por la propia SGT, el IAM, la Dirección General de Calidad u otros servicios municipales', updated_by: 'seed')
	Task.create!(sub_process_id: 10, order: 1, description: 'Tramitación de las revisiones de la renta, las liquidaciones de gastos comunes y demás incidencias de los contratos de arrendamiento de los edificios gestionados por la SGT', updated_by: 'seed')
	Task.create!(sub_process_id: 11, order: 1, description: 'Reservas de auditorios, salas de juntas y aulas de formación y atención de las peticiones de medios audiovisuales para reuniones o cursos', updated_by: 'seed')
	Task.create!(sub_process_id: 11, order: 2, description: 'Ubicación y acondicionamiento de los puestos de trabajo de los empleados del Área', updated_by: 'seed')
	Task.create!(sub_process_id: 11, order: 3, description: 'Gestión de mudanzas', updated_by: 'seed')
	Task.create!(sub_process_id: 12, order: 1, description: 'Traslados de muebles o de material de trabajo', updated_by: 'seed')

puts "Creando indicadores"
	Indicator.create!(task_id: 1, description: 'Número  de  asuntos', updated_by: 'seed')
	Indicator.create!(task_id: 4, description: 'Número de informes solicitados', updated_by: 'seed')
	Indicator.create!(task_id: 5, description: 'Número de proyectos propios tramitados', updated_by: 'seed')
	Indicator.create!(task_id: 6, description: 'Número de proyectos de otras áreas informados', updated_by: 'seed')
	Indicator.create!(task_id: 7, description: '0', updated_by: 'seed')
	Indicator.create!(task_id: 9, description: 'Número de expedientes solicitados', updated_by: 'seed')
	Indicator.create!(task_id: 12, description: 'Número de sentencias', updated_by: 'seed')
	Indicator.create!(task_id: 14, description: 'Número de quejas recibidas', updated_by: 'seed')
	Indicator.create!(task_id: 17, description: 'Número de accesos controlados', updated_by: 'seed')
	Indicator.create!(task_id: 17, description: 'Número de visitas', updated_by: 'seed')
	Indicator.create!(task_id: 19, description: 'Número de peticiones de tarjetas corporativas', updated_by: 'seed')
	Indicator.create!(task_id: 21, description: 'Número de edificios adscritos al Área', updated_by: 'seed')
	Indicator.create!(task_id: 21, description: 'Número de empleados  del Área de Gobierno a 31 de diciembre 2015', updated_by: 'seed')
	Indicator.create!(task_id: 22, description: 'Número de instrucciones difundidas', updated_by: 'seed')
	Indicator.create!(task_id: 23, description: 'Número de contratos de arrendamiento de edificios gestionados por la SGT', updated_by: 'seed')
	Indicator.create!(task_id: 24, description: 'Número de empleados  del Área de Gobierno a 31 de diciembre 2015', updated_by: 'seed')
	Indicator.create!(task_id: 25, description: 'Importe de los contratos de mantenimiento y reparación de mobiliario', updated_by: 'seed')
	Indicator.create!(task_id: 26, description: 'Dotación anual global de las partidas para adquisición de material', updated_by: 'seed')
	Indicator.create!(task_id: 27, description: 'Número total de equipos informáticos', updated_by: 'seed')
	Indicator.create!(task_id: 28, description: 'Número total de equipos de telefonía', updated_by: 'seed')
	Indicator.create!(task_id: 29, description: 'Número de plazas de estacionamiento del  Área de Gobierno', updated_by: 'seed')
	Indicator.create!(task_id: 30, description: 'Número de dependencias de ubicación del Área', updated_by: 'seed')
	Indicator.create!(task_id: 31, description: 'Número de servicios  de conductor demandados', updated_by: 'seed')
	Indicator.create!(task_id: 32, description: 'Número de empleados del Área de Gobierno a 31/12/15', updated_by: 'seed')
	Indicator.create!(task_id: 33, description: 'Número de empleados del Área de Gobierno a 31/12/15', updated_by: 'seed')
	Indicator.create!(task_id: 34, description: 'Número de metros cuadrados de los edificios del Área', updated_by: 'seed')

puts "Creando Tipos de unidades"
	UnitType.create!(organization_type_id: to2, name: "Departamento de Sanidad y Consumo")
	UnitType.create!(organization_type_id: to2, name: "Secretaria General Técnica")
	UnitType.create!(organization_type_id: to1, name: "Departamento de Sanidad y Consumo")
