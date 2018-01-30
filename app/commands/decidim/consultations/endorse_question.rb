# frozen_string_literal: true

module Decidim
  module Consultations
    # A command with all the business logic when a user endorses a question.
    class EndorseQuestion < Rectify::Command
      # Public: Initializes the command.
      #
      # question   - A Decidim::Consultations::Question object.
      # current_user - The current user.
      def initialize(question, current_user)
        @question = question
        @current_user = current_user
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

      def build_endorsement
        @question.endorsements.build(author: @current_user)
      end
    end
  end
end
