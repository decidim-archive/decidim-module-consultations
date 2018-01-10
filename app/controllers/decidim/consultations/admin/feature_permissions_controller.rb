# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # Controller that allows managing the Consultation Feature
      # permissions in the admin panel.
      class FeaturePermissionsController < Decidim::Admin::FeaturePermissionsController
        include ConsultationAdmin
      end
    end
  end
end
