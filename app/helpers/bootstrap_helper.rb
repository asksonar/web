module BootstrapHelper

  def bsh_split_panel(border_panel_class)
    col, size, column = border_panel_class.split('-')
    sizes = ['xs', 'sm', 'md', 'lg']
    visible_index = sizes.find_index(size)
    hidden_sizes = sizes.take(visible_index).map { |size| "hidden-#{size}" }.join(' ')

    raw <<-HTML.chomp!
      <div class='split_panel'>
        <div class='row'>
          <div class='split_panel_border #{border_panel_class} #{hidden_sizes}'></div>
        </div>
      </div>
    HTML
  end

end
