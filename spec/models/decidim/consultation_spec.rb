# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Consultation do
    subject { consultation }

    let(:consultation) { build(:consultation, slug: "my-slug") }

    it { is_expected.to be_valid }

    it "Uses slug when is used as a parameter" do
      expect(consultation.to_param).to eq(consultation.slug)
    end

    describe "upcoming?" do
      context "when voting period starts in the future" do
        let(:consultation) { build(:consultation, :upcoming) }

        it "returns true" do
          expect(consultation).to be_upcoming
        end
      end

      context "when voting period starts in the past" do
        let(:consultation) { build(:consultation, :active) }

        it "returns false" do
          expect(consultation).not_to be_upcoming
        end
      end
    end

    describe "active?" do
      context "when voting period starts in the future" do
        let(:consultation) { build(:consultation, :upcoming) }

        it "returns false" do
          expect(consultation).not_to be_active
        end
      end

      context "when voting period starts in the past" do
        let(:consultation) { build(:consultation, :active) }

        it "returns true" do
          expect(consultation).to be_active
        end
      end
    end

    include_examples "publicable"

    context "when there's a consultation with the same slug in the same organization" do
      let!(:external_assembly) { create :consultation, organization: consultation.organization, slug: "my-slug" }

      it "is not valid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:slug]).to eq ["has already been taken"]
      end
    end

    context "when there's a consultation with the same slug in another organization" do
      let!(:external_assembly) { create :consultation, slug: "my-slug" }

      it { is_expected.to be_valid }
    end
  end
end
