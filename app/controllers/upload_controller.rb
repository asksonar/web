class UploadController < ApplicationController
  before_action :authenticate_researcher!

  def upload
    service.batch_update_metadata(company, metadata)
    render plain: 'OK'
  end

  private

  def metadata
    # to_hash - Collapses the row into a simple Hash. Be warning that this discards field order and clobbers duplicate fields.
    # [1] http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV/Row.html#method-i-to_hash
    CSV.parse(params[:metadata], headers: true).map(&:to_hash)
  end

  def company
    current_researcher.company
  end

  def service
    @service ||= RespondersService.instance
  end
end
