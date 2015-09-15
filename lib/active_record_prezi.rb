module ActiveRecordPrezi
  def prezi
    @prezi ||= Object.const_get(self.class.name + 'Presenter').new(self)
  end
end
