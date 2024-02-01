class CreateCompanyOnboardings < ActiveRecord::Migration[7.0]
  def change
    create_table :company_onboardings, id: :uuid do |t|
      t.string :name,                  null: false, default: ''
      t.string :email,                 null: false, default: ''
      t.string :city,              null: false, default: ''  
      t.string :phone,                 null: false, default: ''
      t.string :address,               null: false, default: ''
      t.boolean :terms,                null: false, default: false
      t.boolean :buyer,                null: false, default: false
      t.boolean :supplier,             null: false, default: false
      t.integer :approval,             null: false, default: 0
      t.text :reason_for_disapproval,  null: false, default: ''
      t.text :about,  null: false, default: ''
      
      t.timestamps
    end

    add_index :company_onboardings, :email,                unique: true
    add_index :company_onboardings, :phone,                unique: true
  end
end
