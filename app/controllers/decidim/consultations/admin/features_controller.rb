# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # Controller that allows managing the Consultation's Features in the
      # admin panel.
      class FeaturesController < Decidim::Admin::FeaturesController
        include ConsultationAdmin
      end
    end
  end
end
