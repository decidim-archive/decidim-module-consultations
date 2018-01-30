# frozen_string_literal: true

module Decidim
  module Consultations
    class QuestionEndorsementsController < Decidim::ApplicationController
      include NeedsQuestion

      before_action :authenticate_user!

      def create
        authorize! :endorse, current_question
        EndorseQuestion.call(current_question, current_user) do
          on(:ok) do
            current_question.reload
            render :update_vote_button
          end

          on(:invalid) do
            render json: {
              error: I18n.t("question_votes.create.error", scope: "decidim.consultations")
            }, status: 422
          end
        end
      end

      def destroy
        authorize! :unvote, current_question
        UnendorseQuestion.call(current_question, current_user) do
          on(:ok) do
            current_question.reload
            render :update_vote_button
          end
        end
      end
    end
  end
end
