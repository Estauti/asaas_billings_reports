class CreateDateRangeFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :date_range_filters do |t|
      t.date :start_date
      t.date :end_date

      t.references :user, null: false
    end
  end
end
