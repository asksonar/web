# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ActiveRecord::Base.transaction do
  template = Template.create!(
    display: 'Sample study',
    value: 'sample',
    scenario_title: 'Sample study: Website first impressions',
    scenario_description: 'It would be very helpful if you could share your first impressions of our website: the good, the bad, the ugly. Thanks in advance!'
  )

  TemplateStep.create!(
    template: template,
    step_description: 'Please browse around the website and tell us your first impressions. Remember to speak your thoughts out loud.',
    step_order: 0,
    step_url: 'www.yahoo.com'
  )
end
