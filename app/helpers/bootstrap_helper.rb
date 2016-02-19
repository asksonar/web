module BootstrapHelper

  def bsh_split_panel(border_panel_class)
    # expecting format like col-md-6
    col, size, column = border_panel_class.split('-')
    hidden_below_size = size
    sizes = %w(xs sm md lg)
    visible_index = sizes.find_index(hidden_below_size)
    hidden_sizes = sizes.take(visible_index).map { |size| "hidden-#{size}" }.join(' ')

    raw <<-HTML.chomp!
      <div class='split_panel'>
        <div class='row'>
          <div class='split_panel_border #{border_panel_class} #{hidden_sizes}'></div>
        </div>
      </div>
    HTML
  end

  # a more 'specific' version of navbar_item
  def bsh_navbar_item(display, url, active: true)
    is_active = active && request.path == url

    raw <<-HTML.chomp!
      <li class='#{is_active ? 'active' : ''}'><a href='#{url}'>#{display}</a></li>
    HTML
  end
end
