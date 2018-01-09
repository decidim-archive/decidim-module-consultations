# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe OrganizationConsultations do
      subject { described_class.new(organization) }

      let!(:organization) { create(:organization) }
      let!(:local_consultations) do
        create_list(:consultation, 3, organization: organization)
      end

      let!(:foreign_consultations) do
        create_list(:consultation, 3)
      end

      describe "query" do
        it "includes the organization's consultations" do
          expect(subject).to include(*local_consultations)
        end

        it "excludes the foreign consultations" do
          expect(subject).not_to include(*foreign_consultations)
        end
      end
    end
  end
end
