class CreateController < ApplicationController
  def index
    @product_templates = Template.product_templates
    @marketing_templates = Template.marketing_templates
  end

  def new
    @template = Template.find_by(value: params[:template])
    @product_templates = Template.product_templates
    @marketing_templates = Template.marketing_templates
  end
end
