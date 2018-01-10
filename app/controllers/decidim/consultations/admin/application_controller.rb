# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # The main admin application controller for consultations
      class ApplicationController < Decidim::Admin::ApplicationController
        layout "decidim/admin/consultations"
      end
    end
  end
end
