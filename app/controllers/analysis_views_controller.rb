class AnalysisViewsController < ApplicationController
  before_action :authenticate_user!
  before_filter :fix_json_params, only: [:create]

  def create
    analysis_view = analysis_views_service.create_analysis_view(
      current_user.company,
      params[:name],
      pivot_params
    )

    render json: {
      name: analysis_view.name,
      hashid: analysis_view.hashid
    }
  end

  def show
    old_analysis_view = current_user.company.analysis_views.where(current_view: true).first()
    new_analysis_view = AnalysisView.find_by_hashid(params[:id])
    analysis_views_service.update_current_view(old_analysis_view, new_analysis_view)

    redirect_to analysis_index_path
  end

  def destroy
    analysis_view = AnalysisView.find_by_hashid(params[:id])
    analysis_views_service.delete_analysis_view(current_user.company, analysis_view)

    flash[:info] = '<strong>Your view has been deleted.</strong>'
    render json: { redirect_url: analysis_index_path }
  end

  private

  def analysis_views_service
    @analysis_views_service ||= AnalysisViewsService.instance
  end

  def fix_json_params
    if request.format.json?
      body = request.body.read
      request.body.rewind
      unless body == ""
        unmunged_body = ActiveSupport::JSON.decode(body)
        params.merge!(unmunged_body)
        params[_wrapper_options[:name]].merge!(unmunged_body)
      end
    end
  end

  def pivot_params
    params.fetch(:pivot_params, {}).permit(
      :filtersArray => [],
      :rowArray => [],
      :colArray => [],
      :attrArray => [],
      :filters => [
        "Aircraft Age": [],
        "Aircraft Series": [],
        "Aircraft Type": [],
        "Build Year": [],
        "Engine Model": [],
        "Engine Variant": [],
        "Operator": [],
        "Operator Country": [],
        "Operator Region": [],
        "Seats Configuration": [],
        "Aircraft Status": [],
        "Aircraft Manufacturer": [],
        "Aircraft Model": []
      ],
      :renderer => [:name, :type],
      :aggregator => [:name, :params => []]
    )
  end
end
