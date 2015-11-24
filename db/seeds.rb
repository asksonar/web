# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def do_templates
  template_purchase = Template.create!(
    display: 'Test your purchase flow',
    value: 'purchase',
    category: 0,
    scenario_title: 'Test your purchase flow',
    scenario_description: "This scenario is to test the process of finding and purchasing an item.  You'll be asked to search for an item on the site, add it to your shopping cart, and then checkout."
  )

  template_purchase.template_steps.create!([{
    step_description: "Please search for a white and gold dress.",
    step_url: 'www.example.com',
    step_order: 0
  }, {
    step_description: "Add the item to your shopping cart.",
    step_order: 1
  }, {
    step_description: "Checkout and purchase the item.",
    step_order: 2
  }])

  template_nps = Template.create!(
    display: 'Get your Net Promoter Score (NPS)',
    value: 'nps',
    category: 1,
    scenario_title: 'Get your Net Promoter Score (NPS)',
    scenario_description: "This is a quick 1 question survey to gauge your impression of us as a company."
  )

  template_nps.template_steps.create!([{
    step_description: "On a scale of 1 to 10, with 1 being the worst and 10 being the best, how likely are you to recommend our service to a friend?",
    step_url: 'www.example.com',
    step_order: 0
  }])

  template_homepage = Template.create!(
    display: 'Review your homepage',
    value: 'homepage',
    category: 1,
    scenario_title: 'Review your homepage',
    scenario_description: "We'd like you to spend a few minutes looking at our site and give us your first impressions.  What stands out to you?  What looks interesting?"
  )

  template_homepage.template_steps.create!([{
    step_description: "We'd like you to spend a few minutes looking at our site and give us your first impressions.  What stands out to you?  What looks interesting?",
    step_url: 'www.example.com',
    step_order: 0
  }])

  template_sample = Template.create!(
    display: 'Sample study',
    value: 'sample',
    scenario_title: 'Sample study: Website first impressions',
    scenario_description: "It would be very helpful if you could share your first impressions of our website: the good, the bad, the ugly. Thanks in advance!"
  )

  template_sample.template_steps.create!([{
    step_description: "Please browse around the website and tell us your first impressions. Remember to speak your thoughts out loud.",
    step_url: 'www.yahoo.com',
    step_order: 0
  }])

  template_signup = Template.create!(
    display: 'Test your signup flow',
    value: 'signup',
    category: 0,
    scenario_title: 'Test your signup flow',
    scenario_description: "This scenario is to test the process of signing up as a new customer on our new site. You'll be asked to visit the site as if it's your first time and then try to create a new account."
  )

  template_signup.template_steps.create!([{
    step_description: "From the homepage here, try to find the signup page.",
    step_url: 'www.example.com',
    step_order: 0
  }, {
    step_description: "Go ahead and signup for a new account.",
    step_order: 1
  }, {
    step_description: "See if you can log out and then log back in.",
    step_order: 2
  }])

  template_existing_user_feedback = Template.create!(
    display: 'Existing user feedback',
    value: 'existing_user_feedback',
    category: 1,
    scenario_title: 'Existing user feedback',
    scenario_description: "Thanks for using our product! As one of our most important users, could you please take a few minutes to share your feedback with us? We would greatly value your feedback so we can keep improving the product and experience."
  )

  template_existing_user_feedback.template_steps.create!([{
    step_description: "What were your most compelling reasons for using our product? What were your biggest concerns?",
    step_url: 'www.example.com',
    step_order: 0
  }, {
    step_description: "What worked well about the process? Any pleasant surprises? Feel free to show us on the website while talking us through your experience.",
    step_order: 1
  }, {
    step_description: "What were some unanticipated hurdles using the product? Could you show us?",
    step_order: 2
  }, {
    step_description: "What were the biggest benefits of using our product?",
    step_order: 3
  }, {
    step_description: "What would you want to make sure new users knew before using our product?",
    step_order: 4
  }, {
    step_description: "Would you recommend our product to a friend? Why or why not?",
    step_order: 5
  }, {
    step_description: "Any final feedback? What can we improve?",
    step_order: 6
  }])

  template_dogfood = Template.create!(
    display: 'Dogfood a feature',
    value: 'dogfood',
    category: 0,
    scenario_title: 'Dogfood a feature',
    scenario_description: "We could really use your feedback on feature XYZ which helps you XYZ. Your candid feedback is critical to making the product even better and we're very thankful of your time!"
  )

  template_dogfood.template_steps.create!([{
    step_description: "Please go to the site and log in.",
    step_url: 'www.example.com',
    step_order: 0
  }, {
    step_description: "Click on feature 1 (2nd from the right on the top nav) and do action 1. Any feedback so far? (remember to speak out loud)",
    step_order: 1
  }, {
    step_description: "Drill into feature 1 with action 2. What worked? What didn't?",
    step_order: 2
  }, {
    step_description: "What would you typically do next?",
    step_order: 3
  }, {
    step_description: "Did feature 1 accomplish what you were hoping? Any parting thoughts?",
    step_order: 4
  }])

  template_mine = Template.create!(
    display: 'My Feedback',
    value: 'mine',
    category: 1,
    scenario_title: 'My Feedback',
    scenario_description: "Please record and share some feedback of your choosing."
  )

  template_mine.template_steps.create!([{
    step_description: "My feedback.",
    step_order: 0
  }])
end

def do_sample_scenario_result
  panelist = Panelist.create(
    email: ''
  )

  scenario = Scenario.create!(
    title: 'Website first impressions',
    description: "It would be very helpful if you could share your first impressions of our website: the good, the bad, the ugly. Thanks in advance!"
  )

  scenario_step = scenario.scenario_steps.create!(
    description: "Please browse around the website and tell us your first impressions. Remember to speak your thoughts out loud.",
    step_order: 0,
    url: 'yahoo.com'
  )

  scenario_result = ScenarioResult.create!({
    scenario: scenario,
    panelist: panelist,
    status: 2 # completed
  })

  scenario_result.result_steps.create!([{
    scenario_step: scenario_step,
    scenario_result: scenario_result,
    completed_seconds: 100.846,
    offset_seconds: 0
  }])

# select
# '    offset_seconds: ' || offset_seconds || ',
#     text: "' || text || '"
#   }, {
# ' from result_transcriptions where scenario_result_id = 1036380636 order by offset_seconds asc

  scenario_result.result_transcriptions.create!([{
    offset_seconds: 3.178,
    text: "great"
  }, {
    offset_seconds: 6.288,
    text: "go around the website and tell us your first impression"
  }, {
    offset_seconds: 9.158,
    text: "speaking thoughts out loud"
  }, {
    offset_seconds: 11.448,
    text: "heard of this company Yahoo but I haven't visited the site in a really long time so yeah my first impression is that there are a ton of links through the tunnel different things to look up there's scroll bar across the top here"
  }, {
    offset_seconds: 30.909,
    text: "on the side"
  }, {
    offset_seconds: 33.019,
    text: "I wonder how it's different from the top than the the left side maybe I'll go check out some sports news"
  }, {
    offset_seconds: 44.049,
    text: "alright there still a lot of links here"
  }, {
    offset_seconds: 49.731,
    text: "let's see"
  }, {
    offset_seconds: 52.58,
    text: "released by Tom Brady"
  }, {
    offset_seconds: 55.879,
    text: "yes it was pretty good I was able to see a highlight that I want to bother why seem so so that's pretty cool"
  }, {
    offset_seconds: 70.355,
    text: "back to the top-level news on Matt Cassel clock on home here"
  }, {
    offset_seconds: 73.201,
    text: "the trending right now maybe I'll click on Heath Ledger"
  }, {
    offset_seconds: 80.05,
    text: "Sentry on him I guess I was expecting some news articles and stuff like that"
  }, {
    offset_seconds: 86.321,
    text: "I guess there's news here but it's kind of nested in the middle of a bunch of search"
  }, {
    offset_seconds: 93.138,
    text: "find out a little bit confusing but overall yeah I had in the Yahoo in a long time and it looks like a lot of content that I can digest pretty quickly"
  }])

  scenario_result.result_videos_uploaded.create!([{
    uuid: 'c32c3bd1-d556-4a02-9252-a6dd97476353',
    offset_seconds: 0,
    length_seconds: 100.846
  }])

end

ActiveRecord::Base.transaction do
# select
# '  template_' || value || ' = Template.create!(
#     display: ''' || display || ''',
#     value: ''' || value || ''',
#     scenario_title: ''' || scenario_title || ''',
#     scenario_description: "' || scenario_description || '"
#     category: ' || category || '
#   )' from templates

# select case when step_url is null then
# '    step_description: "' || step_description || '",
#     step_order: ' || step_order || '
# '
# else
# '    step_description: ''' || step_description || ''',
#     step_url: ''' || step_url || ''',
#     step_order: ' || step_order || '
# '
# end
# from template_steps, templates where templates.id = template_id and value = 'purchase' order by step_order asc

  do_templates
  do_sample_scenario_result
end
