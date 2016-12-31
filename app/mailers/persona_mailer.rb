# Controlador de correos para notificar a los participantes
class PersonaMailer < ApplicationMailer
  def match_message(persona, persona_regalada)
    @persona = persona
    @persona_regalada = persona_regalada

    avatar = @persona_regalada.avatar
    @avatar = nil
    if avatar.present?
      @avatar = avatar.file.filename
      attachments.inline[@avatar] = avatar.file.read
    end

    mail(to: @persona.email,
         subject: 'El consejo de sabios ha decidido que debes regalar a...')
  end
end
