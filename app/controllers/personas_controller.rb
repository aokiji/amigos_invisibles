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
    @persona.update_attributes(params[:persona])
    if (@persona)
      render 'show.json', status: 200
    else
      return head 403
    end
  end

  def shuffle
    @relaciones = {}
    personas = Persona.all.shuffle
    personas.each_with_index do |persona, i| 
      @relaciones[personas[i-1].name] = persona.name
    end

    @relaciones.each do |persona, quien_es_regalado|
      PersonaMailer.match(persona, quien_es_regalado).deliver_now
    end

    return head 200
  end
end
