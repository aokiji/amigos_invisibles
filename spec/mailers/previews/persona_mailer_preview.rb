# Preview all emails at http://localhost:3000/rails/mailers/persona_mailer
class PersonaMailerPreview < ActionMailer::Preview
  def match_message
    personas = Persona.limit(2).all
    PersonaMailer.match_message(*personas)
  end
end
