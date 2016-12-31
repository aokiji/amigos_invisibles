# encoding: utf-8

# Uploader para los avatares de las personas
class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  # Donde se almacenan los avatares
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
