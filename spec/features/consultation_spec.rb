# frozen_string_literal: true

require "spec_helper"

describe "Consultation", type: :feature do
  let(:organization) { create(:organization) }
  let(:consultation) { create(:consultation, :published, organization: organization) }

  before do
    switch_to_host(organization.host)
    visit decidim_consultations.consultation_path(consultation)
  end

  it "Shows the basic consultation data" do
    expect(page).to have_i18n_content(consultation.title)
    expect(page).to have_i18n_content(consultation.subtitle)
    expect(page).to have_i18n_content(consultation.description)
  end

  context "when highlighted questions" do
    let!(:question) { create(:question, :published, consultation: consultation, scope: consultation.highlighted_scope) }

    before do
      switch_to_host(organization.host)
      visit decidim_consultations.consultation_path(consultation)
    end

    it "Shows the highlighted questions section" do
      expect(page).to have_content("Consultations from #{translated consultation.highlighted_scope.name}".upcase)
    end

    it "shows highlighted question details" do
      expect(page).to have_i18n_content(question.title)
      expect(page).to have_i18n_content(question.subtitle)
    end
  end
end
