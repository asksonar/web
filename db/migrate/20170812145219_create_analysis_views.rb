class CreateAnalysisViews < ActiveRecord::Migration
  def change
    create_table :analysis_views do |t|
      t.integer :company_id
      t.string :name
      t.boolean :default_view
      t.boolean :current_view
      t.text :pivot_params

      t.timestamps null: false
    end

    companies = Company.all

    companies.each do |company|
      AnalysisView.create(company_id: company.id)
    end
  end
end
