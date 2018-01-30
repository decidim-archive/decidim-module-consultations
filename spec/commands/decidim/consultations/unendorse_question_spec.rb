# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe UnendorseQuestion do
      let(:subject) { described_class.new(question, user) }

      let(:organization) { create :organization }
      let(:consultation) { create :consultation, organization: organization }
      let(:question) { create :question, consultation: consultation }
      let(:user) { create :user, organization: organization }
      let!(:endorsement) { create :endorsement, author: user, question: question }

      context "when user unendorses the question" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast :ok
        end

        it "removes the endorsement" do
          expect do
            subject.call
          end.to change { Endorsement.count }.by(-1)
        end

        it "decreases the endorsement counter by one" do
          expect do
            subject.call
            question.reload
          end.to change { question.endorsements_count }.by(-1)
        end
      end
    end
  end
end
