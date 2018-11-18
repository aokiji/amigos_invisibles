# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
persona_hash = {
  'Nico' => 'ndls05@gmail.com',
  'Santi' => 'itnas06@gmail.com',
  'Mama' => 'gianella.cicutto@gmail.com',
  'Papa' => 'delossantosvh@hotmail.com',
  'Manolo' => 'manoloj.et@gmail.com',
  'Juan' => 'dlsantosjohn@gmail.com',
  'Maika' => 'maika.dlsantos@gmail.com',
}

persona_hash.each do |nombre, email|
  Persona.where(name: nombre).first_or_create do |persona|
      persona.email = email
  end
end


def bidirectional_restriction(person1_name, person2_name)
  person1 = Persona.find_by_name(person1_name)
  person2 = Persona.find_by_name(person2_name)
  Restriccion.where(persona: person1, restringido: person2).first_or_create
  Restriccion.where(persona: person2, restringido: person1).first_or_create
end

bidirectional_restriction('Papa', 'Mama')
bidirectional_restriction('Maika', 'Manolo')
