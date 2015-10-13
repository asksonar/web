module IndentHelper
  def ih_left_indent(
    left_class: '',
    left_content: '',
    div_class: '',
    padding: 'inherit',
    &block)

    raw <<-HTML.chomp!
      <div class='#{div_class} indent-div'>
        <div class='#{left_class} indent-left'>#{left_content}</div>
        <div style='padding-left:#{padding} indent-content'>
          <span class='#{left_class}'></span>
          #{capture(&block) if block_given?}
        </div>
      </div>
    HTML
  end
end
