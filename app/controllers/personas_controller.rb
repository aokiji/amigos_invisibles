# Gestiona Personas
class PersonasController < ApplicationController
  # GET /personas/
  def index
    @personas = Persona.all
  end

  # GET /personas/:id
  def show
    @persona = Persona.find(params.permit(:id)[:id])
  end

  # PATCH /personas/:id
  def update
    params.permit!
    @persona = Persona.find(params[:id])

    establecer_restricciones(@persona)

    return head 403 unless @persona.update_attributes(params[:persona])
    render 'show.json', status: 200
  end

  # POST /personas/shuffle
  def shuffle
    @relaciones = {}
    100.times do
      personas = Persona.all.shuffle
      personas.each_with_index do |persona, i|
        @relaciones[personas[i - 1]] = persona
      end

      valid = true
      @relaciones.each do |persona, quien_es_regalado|
        next unless persona.restringidos.include?(quien_es_regalado)
        Rails.logger.info "Rechazando asignacion dado que #{persona.name} "\
                          "no puede relacionarse con #{quien_es_regalado.name}"
        valid = false
        break
      end

      next unless valid
      Rails.logger.info "Relaciones aceptadas #{@relaciones.inspect}"
      @relaciones.each do |persona, quien_es_regalado|
        PersonaMailer.match_message(persona, quien_es_regalado).deliver_now
      end

      return head 200
    end

    head 403
  end

  private

  # Extrae de los parametros las restricciones y las aplica sobre
  # el objeto persona
  #
  # @param [Persona] persona
  def establecer_restricciones(persona)
    restricciones = params[:restrictions]
    return unless restricciones.present?
    restricciones = JSON.parse(restricciones)
    persona.restringidos = Persona.where(id: restricciones)
  end
end
