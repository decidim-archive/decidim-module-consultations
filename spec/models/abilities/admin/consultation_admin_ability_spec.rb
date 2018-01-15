# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    module Abilities
      module Admin
        describe ConsultationAdminAbility do
          subject { described_class.new(user, {}) }

          context "when managing consultations" do
            context "when admin user" do
              let(:user) { build(:user, :admin) }

              it { is_expected.to be_able_to(:manage, Decidim::Consultation) }
            end

            context "when regular user" do
              let(:user) { build(:user) }

              it { is_expected.not_to be_able_to(:manage, Decidim::Consultation) }
            end

            context "when guest user" do
              let(:user) { nil }

              it { is_expected.not_to be_able_to(:manage, Decidim::Consultation) }
            end
          end

          context "when managing questions" do
            context "when admin user" do
              let(:user) { build(:user, :admin) }

              it { is_expected.to be_able_to(:manage, Decidim::Consultations::Question) }
            end

            context "when regular user" do
              let(:user) { build(:user) }

              it { is_expected.not_to be_able_to(:manage, Decidim::Consultations::Question) }
            end

            context "when guest user" do
              let(:user) { nil }

              it { is_expected.not_to be_able_to(:manage, Decidim::Consultations::Question) }
            end
          end
        end
      end
    end
  end
end
