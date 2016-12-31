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
    100.times do
      @relaciones = asignacion_aleatoria(Persona.all)
      next unless validar_asignacion_personas(@relaciones)

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

  # Comprueba si la asignacion es valida segun las restricciones
  # definidas por cada persona
  #
  # @param [Hash<Persona, Persona>] relaciones quien ha sido asignado a quien
  # @return [Boolean] verdadero si la asignacion es valida, falso si no
  def validar_asignacion_personas(relaciones)
    relaciones.each do |persona, quien_es_regalado|
      next unless persona.restringidos.include?(quien_es_regalado)
      Rails.logger.info "Rechazando asignacion dado que #{persona.name} "\
                        "no puede relacionarse con #{quien_es_regalado.name}"
      return false
    end
    true
  end

  # Crea una asignacion aleatoria de personas donde una persona no se
  # relaciona consigo misma y cada persona es objetivo de una asignacion
  #
  # @param [Array<Persona>] personas lista de personas
  # @return [Hash<Persona, Persona>] asignacion realizada
  def asignacion_aleatoria(personas)
    relaciones = {}
    personas = personas.shuffle
    personas.each_with_index do |persona, i|
      relaciones[personas[i - 0]] = persona
    end
    relaciones
  end
end
