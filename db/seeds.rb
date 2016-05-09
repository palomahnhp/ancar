# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ description: 'Chicago' }, { description: 'Copenhagen' }])
#   Mayor.create(description: 'Emanuel', city: cities.first)
require 'database_cleaner'

DatabaseCleaner.clean_with :truncation

puts "1. Creando settings"
  Setting.create!(key: "header_logo", value: "Logo Ayuntamiento de Madrid")
  Setting.create!(key: "org_name", value: "Ayuntamiento de Madrid")
  Setting.create!(key: "app_name", value: "Evaluación de la carga de trabajo")

puts "2. Creando tipos de organizaciones"
  to1 = OrganizationType.create!(acronym: "JD", description: "Junta de Distrito",
                 updated_by: "seed")
  to2 = OrganizationType.create!(acronym: "SGT", description: "Secretaria General Técnica",
                 updated_by: "seed")
  to3 = OrganizationType.create!(acronym: "AG", description: "Áreas de Gobierno",
                 updated_by: "seed")
  to4 = OrganizationType.create!(acronym: "OOAA", description: "Organismos Autónomos",
                 updated_by: "seed")

puts "3 Fuentes"
  it_s1 = Item.create!(item_type: 'source', description: 'SAP', updated_by: 'seed')
  it_s2 = Item.create!(item_type: 'source', description: 'GIIM', updated_by: 'seed')
  it_s3 = Item.create!(item_type: 'source', description: 'PLYCA', updated_by: 'seed')
  it_s4 = Item.create!(item_type: 'source', description: 'PLATEA', updated_by: 'seed')
  it_s5 = Item.create!(item_type: 'source', description: 'Inventario', updated_by: 'seed')
  it_s6 = Item.create!(item_type: 'source', description: 'Catálogo', updated_by: 'seed')
  it_s7 = Item.create!(item_type: 'source', description: 'DG Patrimonio', updated_by: 'seed')
  it_s8 = Item.create!(item_type: 'source', description: 'Otras fuentes corporativas', updated_by: 'seed')
  it_s9 = Item.create!(item_type: 'source', description: 'Elaboración propia', updated_by: 'seed')
  it_s10 = Item.create!(item_type: 'source', description: 'Servicio', updated_by: 'seed')

puts "4. Cargando Items"
puts "4.1 Indicadores"
it_i1 = Item.create!(item_type: 'indicator', description: 'Acuerdos Marco', updated_by: 'seed')
it_i2 = Item.create!(item_type: 'indicator', description: 'Alta en el sistema GIIM de los datos básicos de las concesiones y cánones a ingresar, así como sus modificaciones y prórrogas', updated_by: 'seed')
it_i3 = Item.create!(item_type: 'indicator', description: 'Centros Culturales', updated_by: 'seed')
it_i4 = Item.create!(item_type: 'indicator', description: 'Elaboración de la memoria de cumplimiento de objetivos', updated_by: 'seed')
it_i5 = Item.create!(item_type: 'indicator', description: 'Incorporaciones de remanentes de crédito', updated_by: 'seed')
it_i6 = Item.create!(item_type: 'indicator', description: 'Socios de los centros  de mayores', updated_by: 'seed')
it_i7 = Item.create!(item_type: 'indicator', description: 'Suministro de información sobre el estado presupuestario de aplicaciones de gasto y de contratos', updated_by: 'seed')
it_i8 = Item.create!(item_type: 'indicator', description: 'Absentismo escolar ', updated_by: 'seed')
it_i9 = Item.create!(item_type: 'indicator', description: 'Actividades desarrolladas en talleres', updated_by: 'seed')
it_i10 = Item.create!(item_type: 'indicator', description: 'Actividades que se desarrollan en los Centros de Servicios Sociales', updated_by: 'seed')
it_i11 = Item.create!(item_type: 'indicator', description: 'Actividades de servicios complementarios', updated_by: 'seed')
it_i12 = Item.create!(item_type: 'indicator', description: 'Actividades programadas en el distrito en vía publica o en otras dependencias fuera de los Centros culturales', updated_by: 'seed')
it_i13 = Item.create!(item_type: 'indicator', description: 'Actividades programadas en los centros culturales ( no talleres )', updated_by: 'seed')
it_i14 = Item.create!(item_type: 'indicator', description: 'Actuaciones para garantizar la atención social básica en servicios sociales UTS', updated_by: 'seed')
it_i15 = Item.create!(item_type: 'indicator', description: 'Archivo de expedientes ', updated_by: 'seed')
it_i16 = Item.create!(item_type: 'indicator', description: 'Asuntos elevados al Consejo Territorial ', updated_by: 'seed')
it_i17 = Item.create!(item_type: 'indicator', description: 'Atención y ayuda a los perceptores de la renta mínima de inserción', updated_by: 'seed')
it_i18 = Item.create!(item_type: 'indicator', description: 'Atención, orientación e información a los consumidores', updated_by: 'seed')
it_i19 = Item.create!(item_type: 'indicator', description: 'Atención, orientación e información en materia educativa  ', updated_by: 'seed')
it_i20 = Item.create!(item_type: 'indicator', description: 'Auditorías del sistema de autocontrol basado en los principios APPCC ', updated_by: 'seed')
it_i21 = Item.create!(item_type: 'indicator', description: 'Autorizaciones demaniales y cesión de espacios públicos ', updated_by: 'seed')
it_i22 = Item.create!(item_type: 'indicator', description: 'Autorizaciones para uso de edificios municipales.', updated_by: 'seed')
it_i23 = Item.create!(item_type: 'indicator', description: 'Avisas', updated_by: 'seed')
it_i24 = Item.create!(item_type: 'indicator', description: 'Ayudas económicas a familias e infancia y mayores (Cobertura necesidades básicas , escuela infantil y comedor escolar, y otras)', updated_by: 'seed')
it_i25 = Item.create!(item_type: 'indicator', description: 'Calculo de interés en la devolución de ingresos por liquidaciones definitivas por devolver', updated_by: 'seed')
it_i26 = Item.create!(item_type: 'indicator', description: 'Centros de día (CAIL, CAF)', updated_by: 'seed')
it_i27 = Item.create!(item_type: 'indicator', description: 'Centros de mayores del distrito', updated_by: 'seed')
it_i28 = Item.create!(item_type: 'indicator', description: 'Certificaciones de acuerdos ', updated_by: 'seed')
it_i29 = Item.create!(item_type: 'indicator', description: 'Cesiones de espacio público', updated_by: 'seed')
it_i30 = Item.create!(item_type: 'indicator', description: 'Compras centralizadas', updated_by: 'seed')
it_i31 = Item.create!(item_type: 'indicator', description: 'Comunicación Previa  ', updated_by: 'seed')
it_i32 = Item.create!(item_type: 'indicator', description: 'Concesiones administrativas', updated_by: 'seed')
it_i33 = Item.create!(item_type: 'indicator', description: 'Concesiones demaniales', updated_by: 'seed')
it_i34 = Item.create!(item_type: 'indicator', description: 'Confección de liquidación tributarias ', updated_by: 'seed')
it_i35 = Item.create!(item_type: 'indicator', description: 'Consejo Territorial ', updated_by: 'seed')
it_i36 = Item.create!(item_type: 'indicator', description: 'Consejo y Junta de Seguridad', updated_by: 'seed')
it_i37 = Item.create!(item_type: 'indicator', description: 'Consulta Urbanística Común', updated_by: 'seed')
it_i38 = Item.create!(item_type: 'indicator', description: 'Consulta Urbanística Especial', updated_by: 'seed')
it_i39 = Item.create!(item_type: 'indicator', description: 'Contratos  menores', updated_by: 'seed')
it_i40 = Item.create!(item_type: 'indicator', description: 'Contratos  menores (propuesta gastos)', updated_by: 'seed')
it_i41 = Item.create!(item_type: 'indicator', description: 'Contratos derivados del acuerdo Marco', updated_by: 'seed')
it_i43 = Item.create!(item_type: 'indicator', description: 'Contratos menores iniciados', updated_by: 'seed')
it_i44 = Item.create!(item_type: 'indicator', description: 'Convenios', updated_by: 'seed')
it_i45 = Item.create!(item_type: 'indicator', description: 'Declaración Responsable', updated_by: 'seed')
it_i46 = Item.create!(item_type: 'indicator', description: 'Denuncias recibidas', updated_by: 'seed')
it_i47 = Item.create!(item_type: 'indicator', description: 'Denuncias sobre legalidad urbanística', updated_by: 'seed')
it_i48 = Item.create!(item_type: 'indicator', description: 'Denuncias y reclamaciones presentadas OMIC', updated_by: 'seed')
it_i49 = Item.create!(item_type: 'indicator', description: 'Denuncias y reclamaciones resueltas OMIC', updated_by: 'seed')
it_i50 = Item.create!(item_type: 'indicator', description: 'Devolución de garantías', updated_by: 'seed')
it_i51 = Item.create!(item_type: 'indicator', description: 'Devolución ingresos indebidos', updated_by: 'seed')
it_i52 = Item.create!(item_type: 'indicator', description: 'Documentos contables', updated_by: 'seed')
it_i53 = Item.create!(item_type: 'indicator', description: 'Elaboración actas órganos colegiados ', updated_by: 'seed')
it_i54 = Item.create!(item_type: 'indicator', description: 'Elaboración de documentos contables de devolución de ingresos indebidos', updated_by: 'seed')
it_i55 = Item.create!(item_type: 'indicator', description: 'Elaboración de estados de seguimientos de facturas y control de plazos de tramitación', updated_by: 'seed')
it_i56 = Item.create!(item_type: 'indicator', description: 'Elaboración del anteproyecto de presupuestos del Distrito', updated_by: 'seed')
it_i57 = Item.create!(item_type: 'indicator', description: 'Elaboración y control de documentos periódicos de reconocimiento de derechos ', updated_by: 'seed')
it_i58 = Item.create!(item_type: 'indicator', description: 'Elaboración y envío de respuesta a los ciudadanos', updated_by: 'seed')
it_i60 = Item.create!(item_type: 'indicator', description: 'Eventos ', updated_by: 'seed')
it_i61 = Item.create!(item_type: 'indicator', description: 'Expedición de documentos de licencias  ', updated_by: 'seed')
it_i62 = Item.create!(item_type: 'indicator', description: 'Expedientes de contratación ( incluye todos los contratos no menores )', updated_by: 'seed')
it_i63 = Item.create!(item_type: 'indicator', description: 'Expedientes de contratación ( incluye todos los contratos no menores y los no derivados de Acuerdos Marco)', updated_by: 'seed')
it_i64 = Item.create!(item_type: 'indicator', description: 'Expedientes de disciplina urbanística (Orden de legalización, cese y clausura, precinto, paralización y precinto de obras, desahucio administrativo, expedientes sancionadores tramitados)', updated_by: 'seed')
it_i65 = Item.create!(item_type: 'indicator', description: 'Expedientes disciplina urbanística  anteriores a 1 de enero de 2015 sin tramitar', updated_by: 'seed')
it_i66 = Item.create!(item_type: 'indicator', description: 'Expedientes pendientes  a 1 de enero de 2015 ', updated_by: 'seed')
it_i67 = Item.create!(item_type: 'indicator', description: 'Facturación', updated_by: 'seed')
it_i68 = Item.create!(item_type: 'indicator', description: 'Gestión anticipos de caja fija ', updated_by: 'seed')
it_i69 = Item.create!(item_type: 'indicator', description: 'Gestión de personal', updated_by: 'seed')
it_i70 = Item.create!(item_type: 'indicator', description: 'Gestión del registro Terceros', updated_by: 'seed')
it_i71 = Item.create!(item_type: 'indicator', description: 'Información actividades culturales, formativas y deportivas', updated_by: 'seed')
it_i72 = Item.create!(item_type: 'indicator', description: 'Información de Secretaría del Distrito', updated_by: 'seed')
it_i73 = Item.create!(item_type: 'indicator', description: 'Información económica', updated_by: 'seed')
it_i74 = Item.create!(item_type: 'indicator', description: 'Información en materia educativa ', updated_by: 'seed')
it_i75 = Item.create!(item_type: 'indicator', description: 'Información servicios sanitarios, calidad y consumo', updated_by: 'seed')
it_i76 = Item.create!(item_type: 'indicator', description: 'Información sobre servicios sociales ', updated_by: 'seed')
it_i77 = Item.create!(item_type: 'indicator', description: 'Información técnico jurídica', updated_by: 'seed')
it_i78 = Item.create!(item_type: 'indicator', description: 'Información urbanística', updated_by: 'seed')
it_i79 = Item.create!(item_type: 'indicator', description: 'información urbanística ( SOLO ATENCIÓN PRESENCIAL EN DPTO )', updated_by: 'seed')
it_i80 = Item.create!(item_type: 'indicator', description: 'Informes de responsabilidad patrimonial', updated_by: 'seed')
it_i81 = Item.create!(item_type: 'indicator', description: 'Informes procedimientos contenciosos', updated_by: 'seed')
it_i82 = Item.create!(item_type: 'indicator', description: 'Inicio de actuaciones', updated_by: 'seed')
it_i83 = Item.create!(item_type: 'indicator', description: 'Inserción Anuncios BOAM', updated_by: 'seed')
it_i84 = Item.create!(item_type: 'indicator', description: 'Inspecciones  en materia de seguridad alimentaria  ', updated_by: 'seed')
it_i85 = Item.create!(item_type: 'indicator', description: 'Inspecciones de piscinas, peluquerías , piercing, tatuaje, centros recreo y cuidado  infantil, tiendas de animales  ', updated_by: 'seed')
it_i86 = Item.create!(item_type: 'indicator', description: 'Inspecciones en materia de protección animal ', updated_by: 'seed')
it_i87 = Item.create!(item_type: 'indicator', description: 'Inspecciones pendientes de realizarse anteriores a al 1 de enero de 2015 ', updated_by: 'seed')
it_i88 = Item.create!(item_type: 'indicator', description: 'Inspecciones relacionadas con el consumo ', updated_by: 'seed')
it_i89 = Item.create!(item_type: 'indicator', description: 'Inspecciones relacionadas con la legalidad urbanística ( incluye ITE)', updated_by: 'seed')
it_i90 = Item.create!(item_type: 'indicator', description: 'Inspecciones relacionadas con la protección del dominio publico', updated_by: 'seed')
it_i91 = Item.create!(item_type: 'indicator', description: 'Intereses devolución de ingresos, liquidaciones a devolver', updated_by: 'seed')
it_i92 = Item.create!(item_type: 'indicator', description: 'ITES municipales', updated_by: 'seed')
it_i93 = Item.create!(item_type: 'indicator', description: 'Junta Municipal', updated_by: 'seed')
it_i94 = Item.create!(item_type: 'indicator', description: 'Libros de Decretos y Resoluciones ', updated_by: 'seed')
it_i95 = Item.create!(item_type: 'indicator', description: 'Licencia Primera Ocupación y Funcionamiento ', updated_by: 'seed')
it_i96 = Item.create!(item_type: 'indicator', description: 'Licencia Urbanística Procedimiento Ordinario Abreviado', updated_by: 'seed')
it_i97 = Item.create!(item_type: 'indicator', description: 'Licencia Urbanística Procedimiento Ordinario Común ', updated_by: 'seed')
it_i98 = Item.create!(item_type: 'indicator', description: 'Licencias solicitadas y pendientes de resolver anteriores 1 de enero de 2015 ', updated_by: 'seed')
it_i99 = Item.create!(item_type: 'indicator', description: 'Liquidación de contratos', updated_by: 'seed')
it_i100 = Item.create!(item_type: 'indicator', description: 'Mantenimiento de edificios (colegios, edificios e instalaciones deportivas)', updated_by: 'seed')
it_i101 = Item.create!(item_type: 'indicator', description: 'Mayores usuarios de comida, lavandería y ayudas geriátricas a domicilio y realojamiento ', updated_by: 'seed')
it_i102 = Item.create!(item_type: 'indicator', description: 'Mayores usuarios de teleasistencia', updated_by: 'seed')
it_i103 = Item.create!(item_type: 'indicator', description: 'Mayores usuarios del servicio de ayuda a domicilio', updated_by: 'seed')
it_i104 = Item.create!(item_type: 'indicator', description: 'Memoria de cumplimiento de objetivos', updated_by: 'seed')
it_i105 = Item.create!(item_type: 'indicator', description: 'Obras en Colegios, edificios e instalaciones deportivas dentro del acuerdo marco', updated_by: 'seed')
it_i106 = Item.create!(item_type: 'indicator', description: 'Obras otros Edificios dentro de Acuerdo Marco', updated_by: 'seed')
it_i107 = Item.create!(item_type: 'indicator', description: 'Obras Plan de Inversiones Sostenibles', updated_by: 'seed')
it_i108 = Item.create!(item_type: 'indicator', description: 'Ocupaciones Vía Pública/Andamios ', updated_by: 'seed')
it_i109 = Item.create!(item_type: 'indicator', description: 'Ordenes Ejecución (Solares, Vía Pública)', updated_by: 'seed')
it_i110 = Item.create!(item_type: 'indicator', description: 'Otras denuncias', updated_by: 'seed')
it_i111 = Item.create!(item_type: 'indicator', description: 'Otros contratos (no menores)', updated_by: 'seed')
it_i112 = Item.create!(item_type: 'indicator', description: 'Participación en Organos colegiados ', updated_by: 'seed')
it_i113 = Item.create!(item_type: 'indicator', description: 'Participantes en los talleres', updated_by: 'seed')
it_i114 = Item.create!(item_type: 'indicator', description: 'Pasos de Vehículos /Reconstrucción Aceras', updated_by: 'seed')
it_i115 = Item.create!(item_type: 'indicator', description: 'Perros potencialmente peligrosos ', updated_by: 'seed')
it_i116 = Item.create!(item_type: 'indicator', description: 'Plan Especial de Control Urbanístico y Ambiental de los Usos', updated_by: 'seed')
it_i117 = Item.create!(item_type: 'indicator', description: 'Planes de autoprotección', updated_by: 'seed')
it_i118 = Item.create!(item_type: 'indicator', description: 'Premios Certámenes ', updated_by: 'seed')
it_i119 = Item.create!(item_type: 'indicator', description: 'Primera atención, urgencias y entrevistas  en las unidades de trabajo social', updated_by: 'seed')
it_i120 = Item.create!(item_type: 'indicator', description: 'Propuesta de Presupuesto ', updated_by: 'seed')
it_i121 = Item.create!(item_type: 'indicator', description: 'Propuesta inicio expedientes sancionadores', updated_by: 'seed')
it_i122 = Item.create!(item_type: 'indicator', description: 'Propuestas de acuerdo elevadas  a la Junta de Gobierno', updated_by: 'seed')
it_i123 = Item.create!(item_type: 'indicator', description: 'Propuestas de acuerdo elevadas  Junta Municipal de Distrito', updated_by: 'seed')
it_i124 = Item.create!(item_type: 'indicator', description: 'Propuestas de acuerdo elevadas al Pleno', updated_by: 'seed')
it_i125 = Item.create!(item_type: 'indicator', description: 'Propuestas de Decreto elevadas al Concejal- Presidente ', updated_by: 'seed')
it_i126 = Item.create!(item_type: 'indicator', description: 'Propuestas de Resolución elevadas al Gerente ', updated_by: 'seed')
it_i127 = Item.create!(item_type: 'indicator', description: 'Propuestas modificación RPT', updated_by: 'seed')
it_i128 = Item.create!(item_type: 'indicator', description: 'Reajuste de anualidades', updated_by: 'seed')
it_i129 = Item.create!(item_type: 'indicator', description: 'Recepción de sugerencias y reclamaciones', updated_by: 'seed')
it_i130 = Item.create!(item_type: 'indicator', description: 'Recepción y clasificación de correo externo e interno ', updated_by: 'seed')
it_i131 = Item.create!(item_type: 'indicator', description: 'Recursos pendientes anteriores a 1 de enero de 2015', updated_by: 'seed')
it_i132 = Item.create!(item_type: 'indicator', description: 'Recursos presentados', updated_by: 'seed')
it_i133 = Item.create!(item_type: 'indicator', description: 'Recursos resueltos', updated_by: 'seed')
it_i134 = Item.create!(item_type: 'indicator', description: 'Reintegros', updated_by: 'seed')
it_i135 = Item.create!(item_type: 'indicator', description: 'Reservas de Estacionamiento', updated_by: 'seed')
it_i136 = Item.create!(item_type: 'indicator', description: 'Revisión de ITES Edificios Municipales', updated_by: 'seed')
it_i137 = Item.create!(item_type: 'indicator', description: 'Revisiones de precios', updated_by: 'seed')
it_i138 = Item.create!(item_type: 'indicator', description: 'Seguimiento facturación', updated_by: 'seed')
it_i139 = Item.create!(item_type: 'indicator', description: 'Situados (Quioscos Prensa, Flores, etc.)', updated_by: 'seed')
it_i140 = Item.create!(item_type: 'indicator', description: 'Solicitud de provisión de puestos', updated_by: 'seed')
it_i141 = Item.create!(item_type: 'indicator', description: 'Subvenciones concedida ', updated_by: 'seed')
it_i142 = Item.create!(item_type: 'indicator', description: 'Subvenciones solicitadas', updated_by: 'seed')
it_i143 = Item.create!(item_type: 'indicator', description: 'Supervisión tramitación de contratos', updated_by: 'seed')
it_i144 = Item.create!(item_type: 'indicator', description: 'Supervisión tramitación de convenios', updated_by: 'seed')
it_i145 = Item.create!(item_type: 'indicator', description: 'Suspensiones actividad por riesgo sanitario', updated_by: 'seed')
it_i146 = Item.create!(item_type: 'indicator', description: 'Tablón electrónico Edictos ', updated_by: 'seed')
it_i147 = Item.create!(item_type: 'indicator', description: 'Talleres de actividades realizadas', updated_by: 'seed')
it_i148 = Item.create!(item_type: 'indicator', description: 'Terrazas Suelo Privado Uso Público', updated_by: 'seed')
it_i149 = Item.create!(item_type: 'indicator', description: 'Terrazas Suelo Público', updated_by: 'seed')
it_i150 = Item.create!(item_type: 'indicator', description: 'Toma de muestras y gestión de alertas alimentarias', updated_by: 'seed')
it_i151 = Item.create!(item_type: 'indicator', description: 'Total de Autorizaciones de uso de espacios y vías públicas  solicitadas y pendientes  de resolver  al 1 de enero de 2015', updated_by: 'seed')
it_i152 = Item.create!(item_type: 'indicator', description: 'Tramitación de expedientes de modificaciones de crédito', updated_by: 'seed')
it_i153 = Item.create!(item_type: 'indicator', description: 'Unidad gestora Web', updated_by: 'seed')
it_i154 = Item.create!(item_type: 'indicator', description: 'Unidades familiares en seguimiento en unidades de trabajo social', updated_by: 'seed')
it_i155 = Item.create!(item_type: 'indicator', description: 'Resto de contratos no menores', updated_by: 'seed')

puts "4.2 METRICAS"
min_i00 = true
mout_i00 = false
met_i00 = Item.create!(item_type: 'metrica', description: 'nº', updated_by: 'seed')
met_i39 = Item.create!(item_type: 'metrica', description: 'nº de contratos menores tramitados', updated_by: 'seed')
met_i99 = met_i50 = met_i30 = met_i128 = met_i137 = met_i41 = Item.create!(item_type: 'metrica', description: 'nº de expedientes', updated_by: 'seed')
met_i43 = Item.create!(item_type: 'metrica', description: 'nº de contratos menores iniciados', updated_by: 'seed')
met_i63 = Item.create!(item_type: 'metrica', description: 'nº de contratos', updated_by: 'seed')
met_i44 = Item.create!(item_type: 'metrica', description: 'nº de convenios tramitados', updated_by: 'seed')
met_i67 = met_i138 = Item.create!(item_type: 'metrica', description: 'nº de facturas', updated_by: 'seed')
met_i40 = Item.create!(item_type: 'metrica', description: 'nº de propuestas', updated_by: 'seed')
met_i38 = Item.create!(item_type: 'metrica', description: 'nº de consultas', updated_by: 'seed')
met_i52 = Item.create!(item_type: 'metrica', description: 'nº de documentos contables', updated_by: 'seed')

puts "4.3 PROCESOS"
it_mp01 = Item.create!(item_type: 'process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS', updated_by: 'seed')
it_mp02 = Item.create!(item_type: 'process', description: 'AUTORIZACIONES Y CONCESIONES', updated_by: 'seed')
it_mp03 = Item.create!(item_type: 'process', description: 'LICENCIAS ', updated_by: 'seed')
it_mp04 = Item.create!(item_type: 'process', description: 'INSPECCIONES Y PROTECCIÓN DE LA LEGALIDAD', updated_by: 'seed')
it_mp05 = Item.create!(item_type: 'process', description: 'DISCIPLINA', updated_by: 'seed')
it_mp06 = Item.create!(item_type: 'process', description: 'DENUNCIAS ', updated_by: 'seed')
it_mp06 = Item.create!(item_type: 'process', description: 'ELABORACIÓN DE PROYECTOS DE OBRA Y MANTENIMIENTO DE EDIFICIOS PÚBLICOS', updated_by: 'seed')
it_mp07 = Item.create!(item_type: 'process', description: 'REVISION DE ACTOS Y RESOLUCION DE RECURSOS Y RECLAMACIONES', updated_by: 'seed')
it_mp08 = Item.create!(item_type: 'process', description: 'REspONSABILIDAD PATRIMONIAL', updated_by: 'seed')
it_mp09 = Item.create!(item_type: 'process', description: 'ELABORACIÓN DE PROYECTOS DE OBRA Y MANTENIMIENTO DE EDIFICIOS PÚBLICOS', updated_by: 'seed')
it_mp10 = Item.create!(item_type: 'process', description: 'LIMPIEZA Y MANTENIMIENTO VIA PUBLICA', updated_by: 'seed')
it_mp11 = Item.create!(item_type: 'process', description: 'GESTIÓN DE CENTROS Y ACTIVIDADES CULTURALES Y SOCIALES', updated_by: 'seed')
it_mp12 = Item.create!(item_type: 'process', description: 'ESCOLARIZACIÓN Y ACTIVIDADES COMPLEMENTARIAS A LA EDUCACION', updated_by: 'seed')
it_mp13 = Item.create!(item_type: 'process', description: 'SUBVENCIONES, PREMIOS Y TRAMITACION DE AYUDAS ECONOMICAS ', updated_by: 'seed')
it_mp14 = Item.create!(item_type: 'process', description: 'GESTIÓN DE INGRESOS NO TRIBUTARIOS', updated_by: 'seed')
it_mp15 = Item.create!(item_type: 'process', description: 'GESTION DE PRECIOS PUBLICOS Y OTROS INGRESOS DE CARÁCTER TRIBUTARIO', updated_by: 'seed')
it_mp16 = Item.create!(item_type: 'process', description: 'ELABORACIÓN ANTEPROYECTO Y GESTIÓN DEL PRESUPUESTO', updated_by: 'seed')
it_mp17 = Item.create!(item_type: 'process', description: 'ANTICIPOS DE CAJA FIJA', updated_by: 'seed')
it_mp18 = Item.create!(item_type: 'process', description: 'ATENCIÓN AL CIUDADANO', updated_by: 'seed')
it_mp19 = Item.create!(item_type: 'process', description: 'ATENCION A OTRAS DEPENDENCIAS MUNICIPALES', updated_by: 'seed')
it_mp20 = Item.create!(item_type: 'process', description: 'SUGERENCIAS RECLAMACIONES ', updated_by: 'seed')
it_mp21 = Item.create!(item_type: 'process', description: 'ASISTENCIA A ÓRGANOS COLEGIADOS', updated_by: 'seed')
it_mp22 = Item.create!(item_type: 'process', description: 'FE PÚBLICA ', updated_by: 'seed')
it_mp23 = Item.create!(item_type: 'process', description: 'CONTROL JURÍDICO-ADMINISTRATIVO', updated_by: 'seed')
it_mp24 = Item.create!(item_type: 'process', description: 'JEFATURA y GESTIÓN DE PERSONAL', updated_by: 'seed')
it_mp25 = Item.create!(item_type: 'process', description: 'ARCHIVO Y SERVICIOS GENERALES', updated_by: 'seed')
it_mp00 = Item.create!(item_type: 'process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS JURÍDICOS', updated_by: 'seed')

puts "4.4 SUBPROCESOS"
it_sp1_1 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR EL DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp1_2 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR EL DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp1_3 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR EL DEPARTAMENTO DE SERVICIOS ECONÓMICOS', updated_by: 'seed')
it_sp1_4 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR EL DEPARTAMENTO DE ACT CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp1_5 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR LA SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp1_6 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS POR EL DEPARTAMENTO DE SERVICIOS SOCIALES ', updated_by: 'seed')
it_sp1_7 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR EL DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO ', updated_by: 'seed')
it_sp1_8 = Item.create!(item_type: 'sub_process', description: 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS POR LA SECRETARÍA DEL DISTRITO', updated_by: 'seed')
it_sp2_1 = Item.create!(item_type: 'sub_process', description: 'AUTORIZACIONES DE USO DE EspACIOS Y VÍAS PÚBLICAS DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp2_2 = Item.create!(item_type: 'sub_process', description: 'AUTORIZACIONES DE USO DE EspACIOS Y VÍAS PÚBLICAS DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp2_4 = Item.create!(item_type: 'sub_process', description: 'AUTORIZACIONES CONCESIONES UNIDAD SERV CULTURALES , FORMAT Y DEPORTIVAS', updated_by: 'seed')
it_sp2_5 = Item.create!(item_type: 'sub_process', description: 'AUTORIZACIONES SECCIÓN EDUCACIÓN', updated_by: 'seed')
it_sp2_6 = Item.create!(item_type: 'sub_process', description: 'AUTORIZACIONES UNIDAD SERV SOCIALES', updated_by: 'seed')
it_sp3_1 = Item.create!(item_type: 'sub_process', description: 'LICENCIAS URBANÍSTICAS DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp3_2 = Item.create!(item_type: 'sub_process', description: 'LICENCIAS URBANÍSTICAS DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp3_7 = Item.create!(item_type: 'sub_process', description: 'LICENCIAS DEPARTAMENTO DE SERV SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp4_7 = Item.create!(item_type: 'sub_process', description: 'INSPECCIONES DEPARTAMENTO DE SERV SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp4_2 = Item.create!(item_type: 'sub_process', description: 'INSPECCIONES DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp5_1 = Item.create!(item_type: 'sub_process', description: 'EXPTES .DE DISCIPLINA URBANÍSTICA DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp5_2 = Item.create!(item_type: 'sub_process', description: 'EXPTES .DE DISCIPLINA URBANÍSTICA DEPARTAMENTO TÉCNICO ', updated_by: 'seed')
it_sp5_7 = Item.create!(item_type: 'sub_process', description: 'EXPEDIENTES SANCIONADORES DEPARTAMENTO DE SERV SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp6_1 = Item.create!(item_type: 'sub_process', description: 'DENUNCIAS DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp6_2 = Item.create!(item_type: 'sub_process', description: 'DENUNCIAS DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp6_7 = Item.create!(item_type: 'sub_process', description: 'DENUNCIAS DEPARTAMENTO DE SERV SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp7_1 = Item.create!(item_type: 'sub_process', description: 'RECURSOS Y CONTENCIOSOS DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp7_4 = Item.create!(item_type: 'sub_process', description: 'DENUNCIAS Y RECLAMCIONES UNIDAD ACT CULTURALES DEPORT ', updated_by: 'seed')
it_sp8_2 = Item.create!(item_type: 'sub_process', description: 'INFORMES DE REspONSABILIDAD PATRIMONIAL DEPARTAMENTO TÉCNICO', updated_by: 'seed')
it_sp8_1 = Item.create!(item_type: 'sub_process', description: 'INFORMES DE REspONSABILIDAD PATRIMONIAL DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp9_2 = Item.create!(item_type: 'sub_process', description: 'PROYECTOS DE OBRA Y MANTENIMIENTO DE EDIFICIOS PÚBLICOS', updated_by: 'seed')
it_sp10_2 = Item.create!(item_type: 'sub_process', description: 'GESTIÓN DE AVISOS DE MANTENIMIENTO DE VÍA PÚBLICA', updated_by: 'seed')
it_sp11_4 = Item.create!(item_type: 'sub_process', description: 'GESTIÓN DE CENTROS Y ACTIVIDADES CULTURALES', updated_by: 'seed')
it_sp11_6 = Item.create!(item_type: 'sub_process', description: 'GESTIÓN DE CENTROS SERVICIOS SOCIALES Y CENTROS DE MAYORES', updated_by: 'seed')
it_sp12_5 = Item.create!(item_type: 'sub_process', description: 'PROCESOS DE ESCOLARIZACIÓN Y OTRAS ACTIVIDADES', updated_by: 'seed')
it_sp13_3 = Item.create!(item_type: 'sub_process', description: 'SUBVENCIONES Y PREMIOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS', updated_by: 'seed')
it_sp13_5 = Item.create!(item_type: 'sub_process', description: 'SUBVENCIONES Y PREMIOS SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp13_4 = Item.create!(item_type: 'sub_process', description: 'SUBVENCIONES Y PREMIOS UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp13_6 = Item.create!(item_type: 'sub_process', description: 'AYUDAS DEPARTAMENTO SERVICIOS SOCIALES', updated_by: 'seed')
it_sp14_3 = Item.create!(item_type: 'sub_process', description: 'INGRESOS NO TRIBUTARIOS', updated_by: 'seed')
it_sp14_1 = Item.create!(item_type: 'sub_process', description: 'INGRESOS NO TRIBUTARIOS DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp15_1 = Item.create!(item_type: 'sub_process', description: 'LIQUIDACIONES Y EXPEDIENTES DEPARTAMENTO JURÍDICO', updated_by: 'seed')
it_sp15_3 = Item.create!(item_type: 'sub_process', description: 'PRECIOS PÚBLICOS Y OTROS INGRESOS SERVICIOS ECONÓMICOS', updated_by: 'seed')

it_sp16_5 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN  SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp16_1 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN DEPARTAMENTO DE SERVICIOS JURÍDICOS', updated_by: 'seed')
it_sp16_3 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN DEPARTAMENTO DE SERVICIOS ECONÓMICOS', updated_by: 'seed')
it_sp16_7 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO ', updated_by: 'seed')
it_sp16_6 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN DEPARTAMENTO DE SERVICIOS SOCIALES ', updated_by: 'seed')
it_sp16_2 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN DEPARTAMENTO DE SERVICIOS TÉCNICOS ', updated_by: 'seed')
it_sp16_8 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN SECRETARIA DEL DISTRITO ', updated_by: 'seed')
it_sp16_4 = Item.create!(item_type: 'sub_process', description: 'PRESUPUESTACIÓN UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp17_3 = Item.create!(item_type: 'sub_process', description: 'CAJA FIJA DEPARTAMENTO DE SERVICIOS ECONÓMICOS ', updated_by: 'seed')
it_sp18_7 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN AL CIUDADANO DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO ', updated_by: 'seed')
it_sp18_6 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN AL CIUDADANO DEPARTAMENTO DE SERVICIOS SOCIALES', updated_by: 'seed')
it_sp18_2 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN AL CIUDADANO DEPARTAMENTO DE SERVICIOS TÉCNICOS ', updated_by: 'seed')
it_sp18_5 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN AL CIUDADANO SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp18_4 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN AL CIUDADANO UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp18_1 = Item.create!(item_type: 'sub_process', description: 'ATENCIÓN DIRECTA AL CIUDADANO DEPARTAMENTO DE SERVICIOS JURÍDICOS', updated_by: 'seed')
it_sp19_6 = Item.create!(item_type: 'sub_process', description: 'A. DEPENDENCIAS MUNICIPALES DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO ', updated_by: 'seed')
it_sp19_1 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS  DEPENDENCIAS  MUNICIPALES DEPARTAMENTO DE  SERVICIOS JURÍDICOS', updated_by: 'seed')
it_sp19_2 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS  MUNICIPALES DEPARTAMENTO DE SERVICIOS TÉCNICOS', updated_by: 'seed')
it_sp19_5 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS MUNICIPALES  DEPARTAMENTO DE SERVICIOS SOCIALES', updated_by: 'seed')
it_sp19_4 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS MUNICIPALES SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp19_7 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS MUNICIPALES DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp19_8 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS MUNICIPALES SECRETARÍA DEL DISTRITO', updated_by: 'seed')
it_sp19_3 = Item.create!(item_type: 'sub_process', description: 'A. OTRAS DEPENDENCIAS MUNICIPALES UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp20_1 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES DEPARTAMENTO DE SERVICIOS JURÍDICOS', updated_by: 'seed')
it_sp20_7 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp20_6 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES DEPARTAMENTO DE SERVICIOS SOCIALES', updated_by: 'seed')
it_sp20_2 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES DEPARTAMENTO DE SERVICIOS TÉCNICOS ', updated_by: 'seed')
it_sp20_5 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp20_8 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES SECRETARÍA DEL DISTRITO', updated_by: 'seed')
it_sp20_4 = Item.create!(item_type: 'sub_process', description: 'SUGERENCIAS Y RECLAMACIONES UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp21_6 = Item.create!(item_type: 'sub_process', description: 'ASISTENCIA ÓRGANOS COLEGIADOS DEPT. SERVICIOS SOCIALES', updated_by: 'seed')
it_sp21_8 = Item.create!(item_type: 'sub_process', description: 'ASISTENCIA ÓRGANOS COLEGIADOS SECRETARÍA DEL DISTRITO', updated_by: 'seed')
it_sp21_4 = Item.create!(item_type: 'sub_process', description: 'ASISTENCIA ÓRGANOS COLEGIADOS UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp22_8 = Item.create!(item_type: 'sub_process', description: 'FE PUBLICA SECRETARÍA DISTRITO', updated_by: 'seed')
it_sp23_8 = Item.create!(item_type: 'sub_process', description: 'PROPUESTAS ELEVADAS POR SECRETARÍA DISTRITO', updated_by: 'seed')
it_sp24_8 = Item.create!(item_type: 'sub_process', description: 'JEFATURA Y GESTIÓN DE PERSONAL SECRETARIA DISTRITO', updated_by: 'seed')
it_sp25_8 = Item.create!(item_type: 'sub_process', description: 'ARCHIVO DE EXPEDIENTES SECRETARÍA DEL DISTRITO', updated_by: 'seed')

it_sp00_1 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS JURÍDICOS', updated_by: 'seed')
it_sp00_2 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS TÉCNICOS', updated_by: 'seed')
it_sp00_3 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS ECONÓMICOS', updated_by: 'seed')
it_sp00_4 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS', updated_by: 'seed')
it_sp00_5 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS SECCIÓN DE EDUCACIÓN', updated_by: 'seed')
it_sp00_6 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS SOCIALES', updated_by: 'seed')
it_sp00_7 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO', updated_by: 'seed')
it_sp00_8 = Item.create!(item_type: 'sub_process', description: 'OTROS PROCESOS SECRETRÍA DEL DISTRITO', updated_by: 'seed')

puts "4.4 Tareas"
it_tarea = Item.create!(item_type: 'task', description: 'Tarea distritos', updated_by: 'seed')

puts "5. Insertando datos de Distritos en organizations"
    o1 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CENTRO", short_description: "CEN JMD CENTRO", sap_id: "10000002", updated_by: "seed")
    o2 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE ARGANZUELA", short_description: "ARG JMD ARGANZUELA", sap_id: "10000003", updated_by: "seed")
    o3 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE RETIRO", short_description: "RET JMD RETIRO", sap_id: "10000004", updated_by: "seed")
    o4 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE SALAMANCA", short_description: "SAL JMD SALAMANCA", sap_id: "10000005", updated_by: "seed")
    o5 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CHAMARTIN", short_description: "CHM JMD CHAMARTIN", sap_id: "10000006", updated_by: "seed")
    o6 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE TETUAN", short_description: "TET JMD TETUAN", sap_id: "10000007", updated_by: "seed")
    o7 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CHAMBERI", short_description: "CHB JMD CHAMBERI", sap_id: "10000008", updated_by: "seed")
    o8 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE FUENCARRAL-EL PARDO", short_description: "FUE JMD FUENCARRAL", sap_id: "10000009", updated_by: "seed")
    o9 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE MONCLOA-ARAVACA", short_description: "MON JMD MONCLOA", sap_id: "10000010", updated_by: "seed")
    o10 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE LATINA", short_description: "LAT JMD LATINA", sap_id: "10000011", updated_by: "seed")
    o11 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CARABANCHEL", short_description: "CAR JMD CARABANCHEL", sap_id: "10000012", updated_by: "seed")
    o12 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE USERA", short_description: "USE JMD USERA", sap_id: "10000013", updated_by: "seed")
    o13 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE PUENTE DE VALLECAS", short_description: "VAL JMD PUENTE  VALLECAS", sap_id: "10000014", updated_by: "seed")
    o14 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE MORATALAZ", short_description: "MOR JMD MORATALAZ", sap_id: "10000015", updated_by: "seed")
    o15 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE CIUDAD LINEAL", short_description: "C.L JMD CIUDAD LINEAL", sap_id: "10000016", updated_by: "seed")
    o16 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE HORTALEZA", short_description: "HOR JMD HORTALEZA", sap_id: "10000017", updated_by: "seed")
    o17 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VILLAVERDE", short_description: "VIL JMD VILLAVERDE", sap_id: "10000018", updated_by: "seed")
    o18 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VILLA DE VALLECAS", short_description: "VAV JMD VILLA DE VALLECAS", sap_id: "10000019", updated_by: "seed")
    o19 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE VICALVARO", short_description: "VIC JMD VICALVARO", sap_id: "10000020", updated_by: "seed")
    o20 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE SAN BLAS CANILLEJAS", short_description: "SBC JMD SAN BLAS CANILLEJAS", sap_id: "10000021", updated_by: "seed")
    o21 = Organization.create!(organization_type_id: to1.id, description: "JUNTA MUNICIPAL DEL DISTRITO DE BARAJAS", short_description: "BAR JMD BARAJAS", sap_id: "10000022", updated_by: "seed")

puts "6. Creando Tipos de unidades para Distritos"
  ut1 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS JURÍDICOS", organization_type_id: to1.id, updated_by: "seed")
  ut2 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS TÉCNICOS", organization_type_id: to1.id, updated_by: "seed")
  ut3 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS ECONÓMICOS", organization_type_id: to1.id, updated_by: "seed")
  ut4 = UnitType.create!(description: "UNIDAD DE ACTIVIDADES CULTURALES, FORMATIVAS Y DEPORTIVAS", organization_type_id: to1.id, updated_by: "seed")
  ut5 = UnitType.create!(description: "SECCIÓN DE EDUCACIÓN", organization_type_id: to1.id, updated_by: "seed")
  ut6 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SOCIALES", organization_type_id: to1.id, updated_by: "seed")
  ut7 = UnitType.create!(description: "DEPARTAMENTO DE SERVICIOS SANITARIOS, CALIDAD Y CONSUMO", organization_type_id: to1.id, updated_by: "seed")
  ut8 = UnitType.create!(description: "SECRETARÍA DEL DISTRITO", organization_type_id: to1.id, updated_by: "seed")

puts "7. Creando unidades para Distritos"
  UnitType.where(organization_type_id: to1.id).each do |u|
    Organization.where(organization_type_id: to1.id).each do |o|
      Unit.create!(description_sap: u.description, organization_id: o.id, unit_type_id: u.id, updated_by: "seed")
    end
  end

puts "8. Cargando datos Periodo 2015 Distritos"
  pdo1 = Period.create!(organization_type_id: to1.id, description: "Datos correspondientes a 2015",
                 started_at: "01/01/2015", ended_at: "31/12/2015",
                 opened_at: "01/04/2016", closed_at: "30/04/2016",
                 updated_by: "seed")

  puts "8.1 Creando procesos  por departamentos"
    i = 0
    mp1 = MainProcess.create!(period_id: to1.id,item_id: it_mp01.id, order: (i=i+1))
    mp2 = MainProcess.create!(period_id: to1.id,item_id: it_mp02.id, order: (i=i+1))
    mp3 = MainProcess.create!(period_id: to1.id,item_id: it_mp03.id, order: (i=i+1))
    mp4 = MainProcess.create!(period_id: to1.id,item_id: it_mp04.id, order: (i=i+1))
    mp5 = MainProcess.create!(period_id: to1.id,item_id: it_mp05.id, order: (i=i+1))
    mp6 = MainProcess.create!(period_id: to1.id,item_id: it_mp06.id, order: (i=i+1))
    mp7 = MainProcess.create!(period_id: to1.id,item_id: it_mp07.id, order: (i=i+1))
    mp8 = MainProcess.create!(period_id: to1.id,item_id: it_mp08.id, order: (i=i+1))
    mp9 = MainProcess.create!(period_id: to1.id,item_id: it_mp09.id, order: (i=i+1))
    mp10 = MainProcess.create!(period_id: to1.id,item_id: it_mp10.id, order: (i=i+1))
    mp11 = MainProcess.create!(period_id: to1.id,item_id: it_mp11.id, order: (i=i+1))
    mp12 = MainProcess.create!(period_id: to1.id,item_id: it_mp12.id, order: (i=i+1))
    mp13 = MainProcess.create!(period_id: to1.id,item_id: it_mp13.id, order: (i=i+1))
    mp14 = MainProcess.create!(period_id: to1.id,item_id: it_mp14.id, order: (i=i+1))
    mp15 = MainProcess.create!(period_id: to1.id,item_id: it_mp15.id, order: (i=i+1))
    mp16 = MainProcess.create!(period_id: to1.id,item_id: it_mp16.id, order: (i=i+1))
    mp17 = MainProcess.create!(period_id: to1.id,item_id: it_mp17.id, order: (i=i+1))
    mp18 = MainProcess.create!(period_id: to1.id,item_id: it_mp18.id, order: (i=i+1))
    mp19 = MainProcess.create!(period_id: to1.id,item_id: it_mp19.id, order: (i=i+1))
    mp20 = MainProcess.create!(period_id: to1.id,item_id: it_mp20.id, order: (i=i+1))
    mp21 = MainProcess.create!(period_id: to1.id, item_id: it_mp21.id, order: (i=i+1))
    mp22 = MainProcess.create!(period_id: to1.id, item_id: it_mp22.id, order: (i=i+1))
    mp23 = MainProcess.create!(period_id: to1.id, item_id: it_mp23.id, order: (i=i+1))
    mp24 = MainProcess.create!(period_id: to1.id, item_id: it_mp24.id, order: (i=i+1))
    mp25 = MainProcess.create!(period_id: to1.id, item_id: it_mp25.id, order: (i=i+1))
    mp0 = MainProcess.create!(period_id: to1.id, item_id: it_mp00.id, order: (i=i+1))
    MainProcess.all.each do |mp|
      puts  mp.id, Item.find(mp.item_id).description
    end
puts "8.1.1 Proceso #{mp1.id}"
mp = mp1

j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp1_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
    i = 0
    ind = Indicator.create!(task_id: tk.id, item_id: it_i39.id, in: min_i00, out: mout_i00, metric: met_i39.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, item_id: it_i41.id, in: min_i00, out: mout_i00, metric: met_i41.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, item_id: it_i63.id, in: min_i00, out: mout_i00, metric: met_i63.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, item_id: it_i44.id, in: min_i00, out: mout_i00, metric: met_i44.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, item_id: it_i30.id, in: min_i00, out: mout_i00, metric: met_i30.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp1_2.id, order: (j=j+1))
    i = 0
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i43.id, metric: met_i43.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i41.id, metric: met_i41.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i63.id, metric: met_i63.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i30.id, metric: met_i30.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i67.id, metric: met_i67.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp1_3.id, order: (j=j+1))
    i = 0
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i40.id, metric: met_i40.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i138.id, metric: met_i138.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i52.id, metric: met_i52.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i137.id, metric: met_i137.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i128.id, metric: met_i128.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i99.id, metric: met_i99.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i50.id, metric: met_i50.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i30.id, metric: met_i30.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp1_4.id, order: (j=j+1))
    i = 0
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i39.id, metric: met_i00.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i62.id, metric: met_i00.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i30.id, metric: met_i00.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i67.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp1_5.id, order: (j=j+1))
    i = 0
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i39.id, metric: met_i00.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i62.id, metric: met_i00.id, order: (i=i+1))
    ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i67.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp1_6.id, order: (j=j+1))
    i = 0
   tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i43.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i62.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i30.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i44.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i67.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp1_7.id, order: (j=j+1))
   tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i39.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i30.id, metric: met_i00.id, order: (i=i+1))
   ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i67.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.2 Proceso #{mp2.id}"
mp = mp2
j = 0
      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp2_1.id, order: (j=j+1))
        tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
        i = 0
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i151.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i149.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i148.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i114.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i135.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i108.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i60.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i139.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i109.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i33.id, metric: met_i00.id, order: (i=i+1))
      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp2_2.id, order: (j=j+1))
        i = 0
        tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i151.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i149.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i148.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i114.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i135.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i108.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i60.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i139.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i33.id, metric: met_i00.id, order: (i=i+1))

      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp2_4.id, order: (j=j+1))
        i = 0
        tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i33.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i21.id, metric: met_i00.id, order: (i=i+1))

      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp2_5.id, order: (j=j+1))
        tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
        i = 0
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i29.id, metric: met_i00.id, order: (i=i+1))

      sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp2_6.id, order: (j=j+1))
        tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
        i = 0
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i32.id, metric: met_i00.id, order: (i=i+1))
        ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i22.id, metric: met_i00.id, order: (i=i+1))


puts "8.1.3 Proceso #{mp3.id}"
mp = mp3
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp3_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i98.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i31.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i45.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i96.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i97.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i95.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i38.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i37.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i116.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i61.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp3_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i98.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i31.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i45.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i96.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i97.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i95.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i38.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i37.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i116.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp3_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i115.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.4 Proceso #{mp4.id}"
mp = mp4
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp4_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i87.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i89.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i90.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp4_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i84.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i88.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.5 Proceso #{mp5.id}"
mp = mp5
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp5_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i = 0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i65.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i64.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp5_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i65.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i64.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp5_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i121.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i145.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.6 Proceso #{mp6.id}"
mp = mp6
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp6_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i82.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp6_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i47.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp6_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i48.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i49.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i110.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.7 Proceso #{mp7.id}"
mp = mp7
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp7_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i132.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i133.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i81.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i131.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp7_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i46.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.8 Proceso #{mp8.id}"
mp = mp8
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp8_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i80.id, metric: met_i00.id, order: (i=i+1))

  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp8_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i80.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.9 Proceso #{mp9.id}"
mp = mp9
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp9_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i105.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i106.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i107.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i100.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i117.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i136.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i92.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.10 Proceso #{mp10.id}"
mp = mp10
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp10_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i23.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.11 Proceso #{mp11.id}"
mp = mp11
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp11_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i3.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i9.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i12.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i13.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp11_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i10.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i27.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i26.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i147.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i113.id, metric: met_i00.id, order: (i=i+1))

puts "8.1.12 Proceso #{mp12.id}"
mp = mp12
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp12_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i8.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i11.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.13 Proceso #{mp13.id}"
mp = mp13
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp13_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i52.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp13_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i142.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i141.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i134.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp13_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i118.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp13_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i24.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i17.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i101.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i102.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i103.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.14 Proceso #{mp14.id}"
mp = mp14
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp14_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i2.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i57.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp14_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i2.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i57.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.15 Proceso #{mp15.id}"
mp = mp15
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp15_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i34.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i25.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i54.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp15_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i91.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i51.id, metric: met_i00.id, order: (i=i+1))
puts "7.1.16 Proceso #{mp16.id}"
mp = mp16
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp16_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp16_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp16_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i56.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i152.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i70.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp16_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp16_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp16_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp16_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp16_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i120.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i104.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.17 Proceso #{mp17.id}"
mp = mp17
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp17_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i68.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.18 Proceso #{mp18.id}"
mp = mp18
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp18_1.id, order: (j=j+1))
    j = 0
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i77.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp18_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i79.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp18_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i153.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp18_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i19.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp18_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i14.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i119.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i154.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp18_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i18.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.19 Proceso #{mp19.id}"
mp = mp19
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp19_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i77.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp19_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i78.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp19_3.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i73.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp19_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i71.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp19_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i74.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp19_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i76.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp19_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i75.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp19_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i72.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.20 Proceso #{mp20.id}"
mp = mp20
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp20_1.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp20_2.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp20_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp20_5.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp20_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp20_7.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp20_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i129.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i58.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.21 Proceso #{mp21.id}"
mp = mp21
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp21_4.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i35.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp21_6.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i112.id, metric: met_i00.id, order: (i=i+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp21_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i93.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i35.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i36.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.22 Proceso #{mp22.id}"
mp = mp22
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp22_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i53.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i28.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i94.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.23 Proceso #{mp23.id}"
mp = mp23
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp23_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i124.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i122.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i123.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i125.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i126.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i16.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.24 Proceso #{mp24.id}"
mp = mp24
  j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp24_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i69.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i127.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i140.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.25 Proceso #{mp25.id}"
mp = mp25
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp25_8.id, order: (j=j+1))
    tk = Task.create!(sub_process_id: sp.id, item_id: it_tarea.id, order: 1)
      i=0
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i15.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i146.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i83.id, metric: met_i00.id, order: (i=i+1))
      ind = Indicator.create!(task_id: tk.id, in: min_i00, out: mout_i00, item_id: it_i130.id, metric: met_i00.id, order: (i=i+1))
puts "8.1.26 Proceso #{mp0.id}"
mp = mp0
j = 0
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut1.id, item_id: it_sp00_1.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut2.id, item_id: it_sp00_2.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut3.id, item_id: it_sp00_3.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut4.id, item_id: it_sp00_4.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut5.id, item_id: it_sp00_5.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut6.id, item_id: it_sp00_6.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut7.id, item_id: it_sp00_7.id, order: (j=j+1))
  sp = SubProcess.create!(main_process_id: mp.id, unit_type_id: ut8.id, item_id: it_sp00_8.id, order: (j=j+1))
