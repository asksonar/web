class EmbedPresenter
  def initialize(company)
    @company = company
  end

  def load_js_snippet(minify = false)
    js_snippet = ApplicationController.new.render_to_string(
      'embed/load_js_snippet',
      locals: { company_uuid: @company.uuid }
    )

    if minify
      value = Uglifier.new.compile(js_snippet)
    else
      value = js_snippet
    end

    # to_s will just give you back the ActionView::SafeBuffer, which still has html_safe set to true
    # to_str will actually give you back a non-safe string, which allows the erb to then html_escape it
    value.to_str
  end
end
