# frozen_string_literal: true

module Decidim
  module Consultations
    # A command with all the business logic when a user endorses a question.
    class EndorseQuestion < Rectify::Command
      # Public: Initializes the command.
      #
      # form   - A Decidim::Consultations::EndorseForm object.
      # current_user - The current user.
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the vote.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        endorsement = build_endorsement
        if endorsement.save
          broadcast(:ok, endorsement)
        else
          broadcast(:invalid, endorsement)
        end
      end

      private

      attr_reader :form

      def build_endorsement
        form.context.current_question.endorsements.build(
          author: form.context.current_user,
          response: form.response
        )
      end
    end
  end
end
