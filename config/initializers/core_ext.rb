# To prevent english-based confusion when reading code like (created_at < 30.days.ago)
#
# If we read out-loud (created_at < 30.days.ago) we get "is created_at less than 30 days ago?"
# This, however, is a shortening of the question "is created_at less than 30 days ago FROM TODAY?"
# which would be represented as ((Time.now - created_at) < 30.days)
# A more accurate reading of (created_at < 30.days.ago) would be "is created_at BEFORE 30 days ago?"
#
# Style of extending base classes is per http://guides.rubyonrails.org/plugins.html#extending-core-classes
#
Time.class_eval do
  alias_method :before?, :<
  alias_method :after?, :>
end

Date.class_eval do
  alias_method :before?, :<
  alias_method :after?, :>
end
