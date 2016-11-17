class Persona < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  has_many :restricciones, :class_name => 'Restriccion'
  has_many :restringidos, :through => :restricciones
end
