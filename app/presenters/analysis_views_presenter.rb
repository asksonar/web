class AnalysisViewsPresenter
  def initialize(company, pivot_params)
    @company = company
    @pivot_params = pivot_params || {}
  end

  def create_analysis_view(name)
    analysis_views_service.create_analysis_view(@company, name, @pivot_params)
  end

  def update_current_view(hashid)
    old_analysis_view = @company.analysis_views.where(current_view: true).first()
    new_analysis_view = AnalysisView.find_by_hashid(hashid)
    analysis_views_service.update_current_view(old_analysis_view, new_analysis_view)
  end

  def delete_analysis_view(hashid)
  @analysis_view = AnalysisView.find_by_hashid(hashid)
    analysis_views_service.delete_analysis_view(@company, @analysis_view)
  end

  private

  def analysis_views_service
    @analysis_views_service ||= AnalysisViewsService.instance
  end
end
