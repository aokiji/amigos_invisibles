class CrearRestricciones < ActiveRecord::Migration[5.0]
  def change
    create_table :restricciones, id: false do |t|
        t.references :persona, index: false
        t.references :persona, :restringido, index: false
    end
  end
end
