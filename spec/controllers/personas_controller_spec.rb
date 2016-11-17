require 'rails_helper'

RSpec.describe PersonasController, type: :controller do
    describe '#shuffle' do
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
                expect(mails.length).to eq(Persona.count)
            end
        end
    end
end
