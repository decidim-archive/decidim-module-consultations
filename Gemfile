# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.2"

# Declare your gem's dependencies in decidim-initiatives.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "decidim", "~> 0.8.3"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :test, :development do
  gem "byebug"
  gem "capybara", "2.16.1"
  gem "faker"
end

group :development do
  gem "letter_opener_web"
end
