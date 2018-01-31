# frozen_string_literal: true

require "spec_helper"

describe "Question endorsement", type: :system do
  let(:organization) { create(:organization) }
  let(:question) { create :question, :published, consultation: consultation }

  context "when upcoming consultation" do
    let(:consultation) { create(:consultation, :published, :upcoming, organization: organization) }

    before do
      switch_to_host(organization.host)
      visit decidim_consultations.question_path(question)
    end

    it "Page contains a disabled endorse button" do
      expect(page).to have_button(id: "endorse_button")
      expect(page).to have_css("#endorse_button.disabled")
    end

    it "Shows when the endorsement period starts" do
      expect(page).to have_content("Starting from #{I18n.l(question.start_endorsing_date)}")
    end
  end

  context "when finished consultation" do
    let(:consultation) { create(:consultation, :finished, organization: organization) }
    let(:user) { create :user, :confirmed, organization: organization }

    context "and guest user" do
      before do
        switch_to_host(organization.host)
        visit decidim_consultations.question_path(question)
      end

      it "Page do not contains an endorse button" do
        expect(page).not_to have_button(id: "endorse_button")
      end

      it "Page do not contains an unendorse button" do
        expect(page).not_to have_button(id: "unendorse_button")
      end
    end

    context "and authenticated user" do
      context "and never endorsed before" do
        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "Page do not contains an endorse button" do
          expect(page).not_to have_button(id: "endorse_button")
        end

        it "Page do not contains an unendorse button" do
          expect(page).not_to have_button(id: "unendorse_button")
        end
      end

      context "and endorsed before" do
        let!(:endorsement) { create :endorsement, author: user, question: question }

        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "has a disabled unendorse button" do
          expect(page).to have_button(id: "unendorse_button")
          expect(page).to have_css("#unendorse_button.disabled")
        end
      end
    end
  end

  context "when active consultation" do
    let(:consultation) { create(:consultation, :active, organization: organization) }
    let(:user) { create :user, :confirmed, organization: organization }

    context "and guest user" do
      before do
        switch_to_host(organization.host)
        visit decidim_consultations.question_path(question)
      end

      it "Page contains an endorse button" do
        expect(page).not_to have_button("ENDORSE")
      end

      it "Page do not contains an unendorse button" do
        expect(page).not_to have_button(id: "unendorse_button")
      end
    end

    context "and authenticated user" do
      let!(:response) { create :response, question: question }

      context "and never endorsed before" do
        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "Page contains an endorse button" do
          expect(page).to have_link(id: "endorse_button")
        end

        it "unendorse button appears after voting" do
          click_link(id: "endorse_button")
          click_button translated(response.title)
          click_button "Confirm"
          expect(page).to have_button(id: "unendorse_button")
        end
      end

      context "and endorsed before" do
        let!(:endorsement) do
          create :endorsement, author: user, question: question, response: response
        end

        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "contains an unendorse button" do
          expect(page).to have_button(id: "unendorse_button")
        end

        it "endorse button appears after unendorsing" do
          click_button(id: "unendorse_button")
          expect(page).to have_link(id: "endorse_button")
        end
      end
    end
  end
end
