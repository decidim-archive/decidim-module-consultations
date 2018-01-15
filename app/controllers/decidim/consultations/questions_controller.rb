# frozen_string_literal: true

module Decidim
  module Consultations
    # A controller that holds the logic to show questions in a
    # public layout.
    class QuestionsController < Decidim::ApplicationController
      helper_method :current_question

      # TODO: Implement public views
      def show
        authorize! :read, current_question
      end

      private

      def current_question
        @current_cuestion ||= Decidim::Consultations::Question.find_by(id: params[:question_id] || params[:id])
      end
    end
  end
end
