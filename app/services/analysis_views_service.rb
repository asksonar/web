class AnalysisViewsService
  include Singleton

  def create_analysis_view(company, name, pivot_params)
    old_analysis_view=company.analysis_views.where(current_view: true).first()

    new_analysis_view = AnalysisView.create(
      company: company,
      name: name,
      default_view: false,
      pivot_params: pivot_params.to_json
    )

    update_current_view(old_analysis_view, new_analysis_view)
    new_analysis_view
  end

  def delete_analysis_view(company, analysis_view)
    new_analysis_view=company.analysis_views.where(default_view: true).first()
    update_current_view(analysis_view, new_analysis_view)
    analysis_view.destroy
  end

  # def get_datatable_columns(analysis_view)
  #   JSON.parse(analysis_view.datatable_columns)
  # end
  #
  # def get_datatable_filters(analysis_view)
  #   JSON.parse(analysis_view.datatable_filters)
  # end

  def get_saved_views(company)
    company.analysis_views.where.not(default_view: true)
  end

  def update_current_view(old_analysis_view, new_analysis_view)
    return if old_analysis_view == new_analysis_view
    old_analysis_view.update(current_view: false)
    new_analysis_view.update(current_view: true)
  end
end
