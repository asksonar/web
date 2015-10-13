module IndentHelper
  def ih_left_indent(left_class, left_content, indent, &block)
    raw <<-HTML.chomp!
      <div>
        <span class='pull-left #{left_class}'>#{left_content}</span>
        <div style='margin-left:#{indent}'>
          <span class='#{left_class}'></span>
          #{capture(&block) if block_given?}
        </div>
      </div>
    HTML
  end
end
