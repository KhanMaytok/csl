# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
TedefArea.create(name: 'Honorarios y procedimientos')
TedefArea.create(name: 'Procedimientos odontólogicos')
TedefArea.create(name: 'Hotelería, servicio clínico y tópico ')
TedefArea.create(name: 'Exámenes auxiliares de laboratorio')
TedefArea.create(name: 'Exámenes auxiliares por imágenes')
TedefArea.create(name: 'Prótesis')
TedefArea.create(name: 'Medicamentos exonerados de IGV')
TedefArea.create(name: 'Otras prestaciones de Salud')

ClinicArea.create(name: 'HON.QX - Quirúrgicos', tedef_area_id: 1)
ClinicArea.create(name: 'Cons - Tópicos', tedef_area_id: 3)
ClinicArea.create(name: 'Proced - Procedimientos clínicos', tedef_area_id: 3)
ClinicArea.create(name: 'Labor - Laboratorio', tedef_area_id: 4)
ClinicArea.create(name: 'RX X - Rayos X', tedef_area_id: 5)
ClinicArea.create(name: 'ECO - Ecografías', tedef_area_id: 5)
ClinicArea.create(name: 'TAC - Tomografía axial computarizada', tedef_area_id: 5)
ClinicArea.create(name: 'Odonto - Procedimientos Odontológicos', tedef_area_id: 2)
Area.create(name: 'Admisión')
Area.create(name: 'Caja')
Area.create(name: 'Farmacia')
Area.create(name: 'Laboratorio')
Area.create(name: 'Imágenes')
Area.create(name: 'Facturación')
Area.create(name: 'Administración')
Area.create(name: 'Sistemas')

=end


Employee.create(name: 'Fabian', paternal: 'Peña', maternal: 'Jacobo', username: 'sis_fabian', password: '123456', area_id: 8)
Employee.create(name: 'Marivel', paternal: 'Torres', maternal: 'Torres', username: 'adm_marivel', password: '123456', area_id: 7)
