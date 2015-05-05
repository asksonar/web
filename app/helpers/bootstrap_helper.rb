module BootstrapHelper

  def bsh_split_panel(border_panel_class, &block)
    raw <<-HTML.chomp!
      <div class='split_panel'>
        <div class='row'>
          <div class='#{border_panel_class} split_panel_border'></div>
        </div>
        #{capture(&block) if block_given?}
      </div>
    HTML
  end

end
