class Persona < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
end
