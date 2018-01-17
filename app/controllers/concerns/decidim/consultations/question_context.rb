# frozen_string_literal: true

module Decidim
  module Consultations
    # This module, when injected into a controller, ensures there's a
    # Question available and deducts it from the context.
    module QuestionContext
      def self.extended(base)
        base.class_eval do
          include NeedsQuestion

          layout "layouts/decidim/question"

          before_action do
            authorize! :read, current_cuestion
          end
        end
      end

      def ability_context
        super.merge(current_consultation: current_consultation)
      end
    end
  end
end
