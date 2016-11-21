class PersonasController < ApplicationController
  def index
    @personas = Persona.all
  end

  def show
    @persona = Persona.find(params.permit(:id)[:id])
  end

  def update
    params.permit!
    @persona = Persona.find(params[:id])
    restricciones = params[:restrictions]
    if restricciones.present?
        restricciones = JSON.parse(restricciones)
        @persona.restringidos = Persona.where(id: restricciones)
    end

    @persona.update_attributes(params[:persona])
    if (@persona)
      render 'show.json', status: 200
    else
      return head 403
    end
  end

  def shuffle
    @relaciones = {}
    100.times do |try|
        personas = Persona.all.shuffle
        personas.each_with_index do |persona, i|          
          @relaciones[personas[i-1]] = persona
        end

        valid = true
        @relaciones.each do |persona, quien_es_regalado|
            if persona.restringidos.include?(quien_es_regalado)
                Rails.logger.info "Rechazando asignacion dado que #{persona.name} no puede relacionarse con #{quien_es_regalado.name}"
                valid = false
                break
            end
        end

        if valid
            Rails.logger.info "Relaciones aceptadas " + @relaciones.inspect
            @relaciones.each do |persona, quien_es_regalado|
              PersonaMailer.match_message(persona, quien_es_regalado).deliver_now
            end

            return head 200
        end
    end
    return head 403

  end
end
