# frozen_string_literal: true

require "spec_helper"

describe "Homepage", type: :system do
  context "when there's an organization" do
    let(:official_url) { "http://mytesturl.me" }
    let(:organization) { create(:organization, official_url: official_url) }

    before do
      switch_to_host(organization.host)
      visit decidim.root_path
    end

    context "and the organization has an consultation hightlighted" do
      let!(:consultation) { create :consultation, :active, :published, :banner_enabled, organization: organization }

      before do
        switch_to_host(organization.host)
        visit decidim.root_path
      end

      it "shows the consultation title" do
        expect(page).to have_i18n_content(consultation.title)
      end

      it "shows the consultation subtitle" do
        expect(page).to have_i18n_content(consultation.subtitle)
      end
    end

    context "and the organization has an consultation but its not hightlighted" do
      let!(:consultation) { create :consultation, :active, :published, :banner_disabled, organization: organization }

      before do
        switch_to_host(organization.host)
        visit decidim.root_path
      end

      it "shows the consultation title" do
        expect(page).not_to have_i18n_content(consultation.title)
      end

      it "shows the consultation subtitle" do
        expect(page).not_to have_i18n_content(consultation.subtitle)
      end
    end
  end
end
