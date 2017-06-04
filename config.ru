require_relative "config/environment"

use Rack::Cors do
  allow do
    origins "*"
    resource "*", methods:  [:get, :options, :head]
  end
end

run Rails.application
