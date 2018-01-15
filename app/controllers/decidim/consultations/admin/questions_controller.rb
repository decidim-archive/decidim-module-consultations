# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      class QuestionsController < Decidim::Consultations::Admin::ApplicationController
        include QuestionAdmin

        def index
          authorize! :index, Decidim::Consultations::Question
          @questions = collection
        end

        def new
          authorize! :new, Decidim::Consultations::Question
          @form = question_form.instance
        end

        def create
          authorize! :create, Decidim::Consultations::Question
          @form = question_form.from_params(params, current_consultation: current_consultation)

          CreateQuestion.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("questions.create.success", scope: "decidim.admin")
              redirect_to consultation_questions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("questions.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          authorize! :edit, current_question
          @form = question_form.from_model(current_question, current_consultation: current_consultation)
        end

        def update
          authorize! :update, current_question

          @form = question_form
                  .from_params(params, question_id: current_question.id, current_consultation: current_consultation)

          UpdateQuestion.call(current_question, @form) do
            on(:ok) do |question|
              flash[:notice] = I18n.t("questions.update.success", scope: "decidim.admin")
              redirect_to edit_consultation_question_path(current_consultation, question)
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("questions.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          authorize! :destroy, current_question
          current_question.destroy!

          flash[:notice] = I18n.t("questions.destroy.success", scope: "decidim.admin")

          redirect_to consultation_questions_path
        end

        private

        def collection
          @collection ||= current_consultation&.questions
        end

        def ability_context
          super.merge(current_consultation: current_consultation)
        end

        def question_form
          form(QuestionForm)
        end
      end
    end
  end
end
