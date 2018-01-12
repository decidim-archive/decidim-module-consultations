# frozen_string_literal: true

module Decidim
  module Consultations
    # This module, when injected into a controller, ensures there's a
    # Consultation available and deducts it from the context.
    module ConsultationContext
      def self.extended(base)
        base.class_eval do
          include NeedsConsultation

          layout "layouts/decidim/consultation"

          before_action do
            authorize! :read, current_consultation
          end
        end
      end

      def ability_context
        super.merge(current_consultation: current_consultation)
      end
    end
  end
end
