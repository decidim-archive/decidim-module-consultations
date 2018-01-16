# frozen_string_literal: true

module Decidim
  module Consultations
    # A controller that holds the logic to show questions in a
    # public layout.
    class QuestionsController < Decidim::ApplicationController
      helper_method :current_question

      helper Decidim::SanitizeHelper

      # TODO: Implement public views
      def show
        authorize! :read, current_question
      end

      private

      def current_question
        @current_cuestion ||= OrganizationQuestions.for(current_organization).find_by(slug: params[:question_slug] || params[:slug])
      end
    end
  end
end
