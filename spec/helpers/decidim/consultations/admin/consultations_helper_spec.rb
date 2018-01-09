# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    module Admin
      describe ConsultationsHelper do
        describe "consultation_example_slug" do
          it "returns an example slug" do
            expect(helper.consultation_example_slug).to eq("consultation-#{Time.now.utc.year}-#{Time.now.utc.month}-1")
          end
        end
      end
    end
  end
end
