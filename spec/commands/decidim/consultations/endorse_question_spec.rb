# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe EndorseQuestion do
      let(:subject) { described_class.new(form) }

      let(:organization) { create :organization }
      let(:consultation) { create :consultation, organization: organization }
      let(:question) { create :question, consultation: consultation }
      let(:user) { create :user, organization: organization }
      let(:response) { create :response, question: question }
      let(:decidim_consultations_response_id) { response.id }
      let(:attributes) do
        {
          decidim_consultations_response_id: decidim_consultations_response_id
        }
      end

      let(:form) do
        EndorseForm
          .from_params(attributes)
          .with_context(current_user: user, current_question: question)
      end

      context "when user endorses the question" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast :ok
        end

        it "creates an endorsement" do
          expect do
            subject.call
          end.to change { Endorsement.count }.by(1)
        end

        it "increases the endorsement counter by one" do
          expect do
            subject.call
            question.reload
          end.to change { question.endorsements_count }.by(1)
        end
      end

      context "when user tries to endorse twice" do
        let!(:endorse) { create :endorsement, author: user, question: question }

        it "broadcasts invalid" do
          expect { subject.call }.to broadcast(:invalid)
        end
      end
    end
  end
end
