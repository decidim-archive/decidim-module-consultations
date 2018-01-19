# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe VoteQuestion do
      let(:subject) { described_class.new(question, user) }

      let(:organization) { create :organization }
      let(:consultation) { create :consultation, organization: organization }
      let(:question) { create :question, consultation: consultation }
      let(:user) { create :user, organization: organization }

      context "when user votes the question" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast :ok
        end

        it "creates a vote" do
          expect do
            subject.call
          end.to change { Vote.count }.by(1)
        end

        it "increases the vote counter by one" do
          expect do
            subject.call
            question.reload
          end.to change { question.votes_count }.by(1)
        end
      end

      context "when user tries to vote twice" do
        let!(:vote) { create :vote, author: user, question: question }

        it "broadcasts invalid" do
          expect { subject.call }.to broadcast(:invalid)
        end
      end
    end
  end
end
