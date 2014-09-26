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



Employee.create(name: 'Fabian', paternal: 'Peña', maternal: 'Jacobo', username: 'sis_fabian', password: '123456', area_id: 8)
Employee.create(name: 'Marivel', paternal: 'Torres', maternal: 'Torres', username: 'adm_marivel', password: '123456', area_id: 7)

[1,2].each do |i|
	8.times do |j|
	Factor.create(insurance_id: i, clinic_area_id: (j+1).to_i, factor: 5.5)	
	end
end

[3,8,10,13].each do |i|
	Factor.create(insurance_id: i, clinic_area_id: 1, factor: 5)	
	7.times do |j|
		Factor.create(insurance_id: i, clinic_area_id: (j+2).to_i, factor: 5.5)	
	end
end

[6].each do |i|
	8.times do |j|
	Factor.create(insurance_id: i, clinic_area_id: (j+1).to_i, factor: 5.3)	
	end
end

[11,12,15,16].each do |i|
	Factor.create(insurance_id: i, clinic_area_id: 1, factor: 6)	
	7.times do |j|
		Factor.create(insurance_id: i, clinic_area_id: (j+2).to_i, factor: 5)	
	end
end


IndicatorGlobal.create(name: 'Inidividual', code: 'N')
IndicatorGlobal.create(name: 'Global', code: 'S')


PayDocumentType.create(code: '01', name: 'Factura')
PayDocumentType.create(code: '02', name: 'Recibo por honorarios')
PayDocumentType.create(code: '03', name: 'Boleta de venta')
PayDocumentType.create(code: '04', name: 'Liquidación de compra')
PayDocumentType.create(code: '05', name: 'Boleto de aviación comercial para transporte de pasajeros')
PayDocumentType.create(code: '06', name: 'Nota de crédito')
PayDocumentType.create(code: '07', name: 'Nota de débito')
PayDocumentType.create(code: '08', name: 'Ticket o cinta emitida por máquina registradora')
PayDocumentType.create(code: '99', name: 'Otros documentos asignados por la sunat')


a = AfiliationType.find(1)
a.fac_code = '1'
a.save
a = AfiliationType.find(2)
a.fac_code = '3'
a.save
a = AfiliationType.find(3)
a.fac_code = '2'
a.save

DocumentType.create(code: '01', name: 'Solicitud de Atención Médica (Solicitud de Beneficio) / SITEDS')
DocumentType.create(code: '02', name: 'Solicitud de Chequeo Médico / SITEDS')
DocumentType.create(code: '03', name: 'Carta de Garantía')
DocumentType.create(code: '04', name: 'Por código')
DocumentType.create(code: '05', name: 'Voucher')
DocumentType.create(code: '06', name: 'Otro tipo de de Autorización')
DocumentType.create(code: '07', name: 'Declaración accidente')
DocumentType.create(code: '99', name: 'No aplica')


HospitalizationType.create(code: 'C', name: 'Hospitalización Clínica, no se efectúa procedimiento quirúrgico.')
HospitalizationType.create(code: 'Q', name: 'Hospitalización Quirúrgica, se efectúa procedimiento quirúrgico o de naturaleza obstétrica (cesáreas)')

HospitalizationOutputType.create(code: '01', name: 'Alta Médica')
HospitalizationOutputType.create(code: '02', name: 'Alta Voluntaria')
HospitalizationOutputType.create(code: '03', name: 'Transferencia a otro establecimiento de la IAFAS')
HospitalizationOutputType.create(code: '04', name: 'Transferencia a ESSALUD')
HospitalizationOutputType.create(code: '05', name: 'Fuga o Abandono')
HospitalizationOutputType.create(code: '06', name: 'Defunción')
HospitalizationOutputType.create(code: '07', name: 'Egreso de facturación (Sigue hospitalizado)')


Clinic.create(code: '', ruc: '20494306043')

[1,2].each do |i|
	a = Insurance.find(i)
	a.ruc = '20431115825'
	a.save
end

[3,8,10,13].each do |i|
	a = Insurance.find(i)
	a.ruc = '20414955020'
	a.save
end
[11,15].each do |i|
	a = Insurance.find(i)
	a.ruc = '20517182673'
	a.save
end

[12,16].each do |i|
	a = Insurance.find(i)
	a.ruc = '20200380621'
	a.save
end

c = Clinic.find(1)
c.code = '101130C'
c.
Doctor.create(complet_name: 'Rojas Jara Edwin Luciano', document_identity_code: '80015105', tuition_code: '30348')

ServiceExented.create(code: 'A', name: 'Servicio No exonerado de Impuesto')
ServiceExented.create(code: 'D', name: 'Servicio Exonerado de Impuesto')


ProductPharmExented.create(code: 'A', name: 'Producto No exonerado de Impuesto')
ProductPharmExented.create(code: 'D', name: 'Producto Exonerado de Impuesto')


ProductPharmType.create(code: 'C', name: 'Medicamento para el cual se utiliza el catálogo del CUM-SUNASA')
ProductPharmType.create(code: 'R', name: 'Medicamento con receta magistral')
ProductPharmType.create(code: 'I', name: 'Insumo, material médico o prótesis según listado de la SUNASA')
ProductPharmType.create(code: 'O', name: 'Otros productos de farmacia no considerados fármacos, insumos, materiales médicos o insumos')

=end