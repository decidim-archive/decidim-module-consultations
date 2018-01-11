# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe ConsultationsController, type: :controller do
      routes { Decidim::Consultations::Engine.routes }

      let(:organization) { create(:organization) }

      before do
        request.env["decidim.current_organization"] = organization
      end

      describe "GET show" do
        let!(:consultation) do
          create(:consultation, :unpublished, organization: organization)
        end

        context "when the assembly is unpublished" do
          it "redirects to root path" do
            get :show, params: { slug: consultation.slug }

            expect(response).to redirect_to("/")
          end
        end
      end
    end
  end
end
