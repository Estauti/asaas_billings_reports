class ApplicationController < ActionController::Base
  Money.locale_backend = nil

  def update_date_range_filter
    date_range_filter = params.try(:[], :date_range_filter)

    return unless date_range_filter
    return unless date_range_filter.try(:[], :start_date) && date_range_filter.try(:[], :end_date)

    current_user.date_range_filter.update(params[:date_range_filter])
  end
end
