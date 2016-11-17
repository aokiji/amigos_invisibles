class CrearRestricciones < ActiveRecord::Migration[5.0]
  def change
    create_table :restricciones do |t|
        t.references :persona
        t.references :persona, :restringido
    end
  end
end
