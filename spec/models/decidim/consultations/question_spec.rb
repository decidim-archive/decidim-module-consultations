# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe Question do
      subject { question }

      let(:question) { build(:question) }

      it { is_expected.to be_valid }

      describe "hashtag" do
        let(:question) { build :question, hashtag: "#hashtag" }

        it "Do not includes the hash character" do
          expect(question.hashtag).to eq("hashtag")
        end
      end

      include_examples "publicable"
    end
  end
end
