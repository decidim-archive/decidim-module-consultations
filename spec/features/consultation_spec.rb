# frozen_string_literal: true

require "spec_helper"

describe "Consultation", type: :feature do
  let(:organization) { create(:organization) }
  let(:consultation) { create(:consultation, :published) }

  before do
    switch_to_host(organization.host)
    visit decidim_consultations.consultation_path(consultation)
  end

  it "Shows the basic consultation data" do
    expect(page).to have_content(consultation.title[:en])
    expect(page).to have_content(consultation.subtitle[:en])
    expect(page).to have_content(consultation.description[:en])
  end
end
