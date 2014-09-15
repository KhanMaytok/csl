# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin
ClinicArea.create(name: 'Cirugía')
ClinicArea.create(name: 'Procedimientos Especiales')
ClinicArea.create(name: 'Laboratorio')
ClinicArea.create(name: 'Rayos x')
ClinicArea.create(name: 'Ecografía')
ClinicArea.create(name: 'Tomografía')
ClinicArea.create(name: 'Resonancia Magnética')
ClinicArea.create(name: 'Medicina Nuclear')
ClinicArea.create(name: 'Magalab')


Speciality.create(name: 'Cardiología')
Speciality.create(name: 'Otorrinolaringología')
Speciality.create(name: 'Cirugía General')
Speciality.create(name: 'Estomatología')
Speciality.create(name: 'Geriatría')
Speciality.create(name: 'Pediatría')
Speciality.create(name: 'Ginecología')
Speciality.create(name: 'Urología')
Speciality.create(name: 'Neurología')
Speciality.create(name: 'Nefrología')

Doctor.create(tuition_code: '15684353', document_identity_type_id: 1, document_identity_code: '72446835', card_number: '486247888', name: 'Ricardo', paternal: 'Suarez', maternal: 'Mendez', speciality_id: 4)
Doctor.create(tuition_code: '56789043', document_identity_type_id: 1, document_identity_code: '14725836', card_number: '741852963', name: 'Gerardo', paternal: 'Sanchez', maternal: 'Atuncar', speciality_id: 8)
Doctor.create(tuition_code: '54332167', document_identity_type_id: 1, document_identity_code: '74185263', card_number: '147258369', name: 'Pablo', paternal: 'Cayampi', maternal: 'Espino', speciality_id: 1)
Doctor.create(tuition_code: '12389056', document_identity_type_id: 1, document_identity_code: '25896346', card_number: '753421869', name: 'André', paternal: 'Pillaca', maternal: 'Quispe', speciality_id: 2)

=end