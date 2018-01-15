# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # This module, when injected into a controller, ensures there's a
      # Consultation available and deducts it from the context.
      module ConsultationContext
        def self.extended(base)
          base.class_eval do
            include ConsultationAdmin

            alias_method :current_consultation, :current_participatory_space
          end
        end
      end
    end
  end
end
