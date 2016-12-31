# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PersonasController, type: :controller do
  describe '#update' do
    let!(:persona) { create(:persona) }
    it 'actualiza datos generales de la persona' do
      new_name = persona.name + '-suffix'
      expect do
        patch :update, params: {
          id: persona.id,
          persona: { name: new_name }
        }
      end.to change { Persona.find(persona.id).name }
        .from(persona.name).to(new_name)
      expect(response).to have_http_status(:success)
    end

    it 'devuelve error si no puede actualizar' do
      new_name = persona.name + '-suffix'
      allow_any_instance_of(Persona).to receive(:save).and_return(false)

      patch :update, params: {
        id: persona.id,
        persona: { name: new_name }
      }
      expect(response).not_to have_http_status(:success)
    end

    it 'establece restricciones a una persona' do
      otras_personas = create_list(:persona, 2)

      patch :update, params: {
        id: persona.id,
        persona: { name: persona.name },
        restrictions: otras_personas.map(&:id).to_json
      }

      persona.reload
      expect(persona.reload.restringidos).to eq(otras_personas)
      expect(response).to have_http_status(:success)
    end
  end

  describe '#show' do
    let(:persona) { create(:persona) }

    it 'recupera la persona de la base de datos' do
      get :show, params: { id: persona.id }, format: :json

      expect(response).to have_http_status(:success)
      expect(assigns(:persona)).to eq(persona)
    end
  end

  describe '#shuffle' do
    before(:each) { ActionMailer::Base.deliveries.clear }

    context 'sin restricciones' do
      before :each do
        Restriccion.destroy_all
        create_list(:persona, 10)
      end

      it 'realiza una asignacion valida y envia los correos' do
        get :shuffle

        expect(response).to have_http_status(200)
        mails = ActionMailer::Base.deliveries
        expect(mails.length).to eq(Persona.count)
      end
    end

    context 'restricciones imposibles' do
      before :each do
        Restriccion.destroy_all
        personas = create_list(:persona, 10)
        personas.each do |p|
          p.restricciones.create(restringido_id: personas.first.id)
        end
      end

      it 'lo intenta pero le resulta imposible' do
        get :shuffle

        expect(response).to have_http_status(403)
        mails = ActionMailer::Base.deliveries
        expect(mails).to be_empty
      end
    end
  end
end
