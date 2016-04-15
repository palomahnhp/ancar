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

puts "Creando procesos"
    Mainprocess.create!(descripcion: 'RÉGIMEN JURÍDICO')
	Mainprocess.create!(descripcion: 'RÉGIMEN INTERIOR')
	Mainprocess.create!(descripcion: 'GESTIÓN PRESUPUESTARIA')
	Mainprocess.create!(descripcion: 'RECURSOS HUMANOS')
	Mainprocess.create!(descripcion: 'GESTIÓN DE FONDOS DOCUMENTALES')
	Mainprocess.create!(descripcion: 'REGISTRO Y ATENCIÓN AL CIUDADANO')
	Mainprocess.create!(descripcion: 'GASTOS')

puts "Creando subprocesos"
  Subprocess.create!(descripcion: 'LIBRO DE RESOLUCIONES')

puts "Creando tareas"
	Task.create!(descripcion: 'Revisión jurídica, preparación de documentación y petición de informes de los asuntos a tratar en la Comisión Preparatoria con carácter previo a su elevación a la Junta de Gobierno')
	Task.create!(descripcion: 'Revisión jurídica, preparación de documentación y petición de informes de asuntos que el titular del Área de Gobierno eleva para su aprobación a la Junta de Gobierno o al Pleno del Ayuntamiento de Madrid')
	Task.create!(descripcion: 'Revisión jurídica, preparación de documentación, petición de informes sobre asuntos de competencia de las Comisiones del Pleno y asistencia a las sesiones')
	Task.create!(descripcion: 'Elaboración de informes sobre asuntos de otras Áreas de Gobierno incluidos en el orden del día de Comisión Preparatoria, Junta de Gobierno o Pleno')
	Task.create!(descripcion: 'Preparación, revisión y tramitación de proyectos de Ordenanzas y Reglamentos impulsados por el Área de Gobierno: preparación del proyecto inicial, solicitud de informes preceptivos, análisis de observaciones y enmiendas y redacción definitiva')
	Task.create!(descripcion: 'Redacción de informes sobre proyectos de carácter normativo (Ordenanzas, Reglamentos) impulsados por las restantes Áreas de Gobierno')
	Task.create!(descripcion: 'Remisión mensual a la Secretaría General del Pleno de la información a que se refiere el artículo 22 del ROP: contratos adjudicados, convenios celebrados, modificaciones presupuestarias y ejecución presupuestaria')
	Task.create!(descripcion: 'Remisión trimestral a la Secretaría General del Pleno de la información sobre ejecución presupuestaria y de los balances y cuentas de pérdidas y ganancias de las sociedades mercantiles municipales (art.7 Bases de Ejecución del Presupuesto)')
	Task.create!(descripcion: 'Solicitud expediente')
	Task.create!(descripcion: 'Envío al juzgado')
	Task.create!(descripcion: 'Comunicación de sentencia')
	Task.create!(descripcion: 'Solicitud de financiación')
	Task.create!(descripcion: 'Actuaciones de ejecución')
	Task.create!(descripcion: 'Remisión a los órganos directivos competentes para su contestación de las quejas dirigidas por los ciudadanos a la Defensora del Pueblo en materias o servicios competencia del Área de Gobierno')
	Task.create!(descripcion: 'Revisión de las contestaciones de los órganos directivos')
	Task.create!(descripcion: 'Remisión de la contestación al Área de Gobierno competente para su traslado a la Defensora del Pueblo')
	Task.create!(descripcion: 'Revisión de los partes diarios del personal de seguridad de los edificios y gestión de las incidencias')
	Task.create!(descripcion: 'Tareas de control de los accesos')
	Task.create!(descripcion: 'Atención a las comunicaciones de altas y bajas de personal y a las solicitudes provisionales  de tarjetas corporativas')
	Task.create!(descripcion: 'Solicitud de activación de las tarjetas corporativas para la entrada en edificios del Área')
	Task.create!(descripcion: 'Revisión periódica de planes de autoprotección y medidas de emergencia implantados')
	Task.create!(descripcion: 'Cambios del personal que integra los equipos de emergencia comunicándoselo al Comité de Seguridad y Salud')
	Task.create!(descripcion: 'Organización de los cursos de formación del personal del Área en materia de evacuación')
	Task.create!(descripcion: 'Organización y seguimiento de los simulacros de evacuación de los edificios')
	Task.create!(descripcion: 'Análisis de los informes de la realización del simulacro y adopción de las medidas correspondientes')
	Task.create!(descripcion: 'Participación en la elaboración y seguimiento de las evaluaciones de riesgo que realizan los Servicios de Prevención del Ayuntamiento')
	Task.create!(descripcion: 'Gestión de la coordinación de actividades empresariales en materia de prevención de riesgos laborales con las empresas adjudicatarias de los contratos gestionados por la S.G.T.')
	Task.create!(descripcion: 'Atención de las solicitudes e incidencias en materia de prevención de riesgos laborale')
	Task.create!(descripcion: 'Participación en las reuniones de Comité de Seguridad y Salud')
	Task.create!(descripcion: 'Gestión del mantenimiento de los botiquines de primeros auxilios ubicados en los edificios')
	Task.create!(descripcion: 'Solicitud a la Sección de Control de Vectores de las revisiones periódicas de los edificios y comunicación de la aparición de vectores')
	Task.create!(descripcion: 'Difusión a las Direcciones Generales a través del correo electrónico de  instrucciones o procedimientos en materia de régimen interior que se establecen por la propia SGT, el IAM, la Dirección General de Calidad u otros servicios municipales')
	Task.create!(descripcion: 'Tramitación de las revisiones de la renta, las liquidaciones de gastos comunes y demás incidencias de los contratos de arrendamiento de los edificios gestionados por la SGT')
	Task.create!(descripcion: 'Reservas de auditorios, salas de juntas y aulas de formación y atención de las peticiones de medios audiovisuales para reuniones o cursos')
	Task.create!(descripcion: 'Ubicación y acondicionamiento de los puestos de trabajo de los empleados del Área')
	Task.create!(descripcion: 'Gestión de mudanzas')
	Task.create!(descripcion: 'Traslados de muebles o de material de trabajo')
	Task.create!(descripcion: 'Mantenimiento y reparación de muebles y equipos de oficina')
	Task.create!(descripcion: 'Atención de las peticiones de material de oficina y de material inventariable en compra centralizada o mediante la tramitación de contratos menores')
	Task.create!(descripcion: 'Atención de las peticiones de material de imprenta mediante el Catálogo y a través de PLYCA')
	Task.create!(descripcion: 'Adquisición del vestuario de Conductores y POSI')
	Task.create!(descripcion: 'Solicitud al IAM de  las peticiones de telefonía, suministros informáticos  y nuevos equipos informáticos')
	Task.create!(descripcion: 'Control del material  de telefonía y equipos informáticos')
	Task.create!(descripcion: 'Solicitud de tarjetas de estacionamiento oficial al Área de Medio Ambiente y Movilidad')
	Task.create!(descripcion: 'Gestión de plazas de garaje')
	Task.create!(descripcion: 'Gestión del personal POSI para atender las necesidades de traslado de documentación, recepción y reparto de correo')
	Task.create!(descripcion: 'Atención de peticiones de servicio de traslado en vehículo oficial a través de los conductores')
	Task.create!(descripcion: 'Gestión de las incidencias de los vehículos oficiales: averías, siniestros, multas y revisiones')
	Task.create!(descripcion: 'Traslado de personas o documentación')
	Task.create!(descripcion: 'Funciones propias de oficios internos')
	Task.create!(descripcion: 'Funciones propias de mozos u operarios')

puts "Creando indicadores"
	Indicator.create!(descripcion: 'Número  de  asuntos')
	Indicator.create!(descripcion: 'Número de informes solicitados')
	Indicator.create!(descripcion: 'Número de proyectos propios tramitados')
	Indicator.create!(descripcion: 'Número de proyectos de otras áreas informados')
	Indicator.create!(descripcion: '')
	Indicator.create!(descripcion: 'Número de expedientes solicitados')
	Indicator.create!(descripcion: 'Número de sentencias')
	Indicator.create!(descripcion: 'Número de quejas recibidas')
	Indicator.create!(descripcion: 'Número de accesos controlados')
	Indicator.create!(descripcion: 'Número de visitas')
	Indicator.create!(descripcion: 'Número de peticiones de tarjetas corporativas')
	Indicator.create!(descripcion: 'Número de edificios adscritos al Área')
	Indicator.create!(descripcion: 'Número de empleados  del Área de Gobierno a 31 de diciembre 2015')
	Indicator.create!(descripcion: 'Número de instrucciones difundidas')
	Indicator.create!(descripcion: 'Número de contratos de arrendamiento de edificios gestionados por la SGT')
	Indicator.create!(descripcion: 'Número de empleados  del Área de Gobierno a 31 de diciembre 2015')
	Indicator.create!(descripcion: 'Importe de los contratos de mantenimiento y reparación de mobiliario')
	Indicator.create!(descripcion: 'Dotación anual global de las partidas para adquisición de material')
	Indicator.create!(descripcion: 'Número total de equipos informáticos')
	Indicator.create!(descripcion: 'Número total de equipos de telefonía')
	Indicator.create!(descripcion: 'Número de plazas de estacionamiento del  Área de Gobierno')
	Indicator.create!(descripcion: 'Número de dependencias de ubicación del Área')
	Indicator.create!(descripcion: 'Número de servicios  de conductor demandados')
	Indicator.create!(descripcion: 'Número de empleados del Área de Gobierno a 31/12/15')
	Indicator.create!(descripcion: 'Número de empleados del Área de Gobierno a 31/12/15')
	Indicator.create!(descripcion: 'Número de metros cuadrados de los edificios del Área')






