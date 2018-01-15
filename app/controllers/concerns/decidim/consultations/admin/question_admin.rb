# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Consultations
    module Admin
      # This concern is meant to be included in all controllers that are scoped
      # into an question's admin panel. It will override the layout so it shows
      # the sidebar, preload the consultation, etc.
      module QuestionAdmin
        extend ActiveSupport::Concern

        included do
          include NeedsConsultation
          include NeedsQuestion

          layout "decidim/admin/consultation"

          alias_method :current_participatory_space, :current_question
        end
      end
    end
  end
end
