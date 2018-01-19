# frozen_string_literal: true

module Decidim
  module Consultations
    # A command with all the business logic when a user votes a question.
    class VoteQuestion < Rectify::Command
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
        vote = build_vote
        if vote.save
          broadcast(:ok, vote)
        else
          broadcast(:invalid, vote)
        end
      end

      private

      def build_vote
        @question.votes.build(author: @current_user)
      end
    end
  end
end
