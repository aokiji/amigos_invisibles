# Una persona puede tener restricciones sobre a quien puede regalar
class Restriccion < ApplicationRecord
  self.table_name = 'restricciones'

  belongs_to :persona
  belongs_to :restringido, foreign_key: 'restringido_id', class_name: 'Persona'
end
