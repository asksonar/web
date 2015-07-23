module WorkersVideo
  class Railtie < Rails::Railtie
    railtie_name :workers_video

    rake_tasks do
      load "tasks/resque.rake"
    end
  end
end
