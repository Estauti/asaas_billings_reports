class ApplicationController < ActionController::Base
  Money.locale_backend = nil

  def update_date_range_filter
    return unless params.try(:[], :start_date)
    return unless params.try(:[], :end_date)

    current_user.date_range_filter.update(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )
  end
end
