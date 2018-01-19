# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe UnvoteQuestion do
      let(:subject) { described_class.new(question, user) }

      let(:organization) { create :organization }
      let(:consultation) { create :consultation, organization: organization }
      let(:question) { create :question, consultation: consultation }
      let(:user) { create :user, organization: organization }
      let!(:vote) { create :vote, author: user, question: question }

      context "when user unvotes the question" do
        it "broadcasts ok" do
          expect(vote).to be_valid
          expect { subject.call }.to broadcast :ok
        end

        it "removes the vote" do
          expect(vote).to be_valid
          expect do
            subject.call
          end.to change { Vote.count }.by(-1)
        end

        it "decreases the vote counter by one" do
          expect do
            subject.call
            question.reload
          end.to change { question.votes_count }.by(-1)
        end
      end
    end
  end
end
