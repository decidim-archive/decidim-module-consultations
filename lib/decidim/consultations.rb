# frozen_string_literal: true

require "decidim/consultations/admin"
require "decidim/consultations/engine"
require "decidim/consultations/admin_engine"
require "decidim/consultations/participatory_space"

module Decidim
  # Base module for the consultations engine.
  module Consultations
    include ActiveSupport::Configurable
  end
end
