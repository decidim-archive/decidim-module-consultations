# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # This module, when injected into a controller, ensures there's a
      # Question available and deducts it from the context.
      module QuestionContext
        def self.extended(base)
          base.class_eval do
            include QuestionAdmin

            alias_method :current_question, :current_participatory_space
          end
        end
      end
    end
  end
end
