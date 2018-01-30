# frozen_string_literal: true

require "spec_helper"

describe "Question voting", type: :system do
  let(:organization) { create(:organization) }
  let(:question) { create :question, :published, consultation: consultation }

  context "when upcoming consultation" do
    let(:consultation) { create(:consultation, :published, :upcoming, organization: organization) }

    before do
      switch_to_host(organization.host)
      visit decidim_consultations.question_path(question)
    end

    it "Page contains a disabled vote button" do
      expect(page).to have_button(id: "vote_button")
      expect(page).to have_css("#vote_button.disabled")
    end

    it "Shows when the voting period starts" do
      expect(page).to have_content("Starting from #{I18n.l(question.start_voting_date)}")
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

      it "Page do not contains a vote button" do
        expect(page).not_to have_button(id: "vote_button")
      end

      it "Page do not contains an unvote button" do
        expect(page).not_to have_button(id: "unvote_button")
      end
    end

    context "and authenticated user" do
      context "and never voted before" do
        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "Page do not contains a vote button" do
          expect(page).not_to have_button(id: "vote_button")
        end

        it "Page do not contains an unvote button" do
          expect(page).not_to have_button(id: "unvote_button")
        end
      end

      context "and voted before" do
        let!(:endorse) { create :endorse, author: user, question: question }

        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "has a disabled unvote button" do
          expect(page).to have_button(id: "unvote_button")
          expect(page).to have_css("#unvote_button.disabled")
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

      it "Page contains a vote button" do
        expect(page).not_to have_button(id: "vote_button")
      end

      it "Page do not contains an unvote button" do
        expect(page).not_to have_button(id: "unvote_button")
      end
    end

    context "and authenticated user" do
      context "and never voted before" do
        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "Page contains a vote button" do
          expect(page).to have_button(id: "vote_button")
        end

        it "unvote button appears after voting" do
          click_button(id: "vote_button")
          expect(page).to have_button(id: "unvote_button")
        end
      end

      context "and voted before" do
        let!(:endorse) { create :endorse, author: user, question: question }

        before do
          switch_to_host(organization.host)
          login_as user, scope: :user, run_callbacks: false
          visit decidim_consultations.question_path(question)
        end

        it "contains an unvote button" do
          expect(page).to have_button(id: "unvote_button")
        end

        it "vote button appears after unvoting" do
          click_button(id: "unvote_button")
          expect(page).to have_button(id: "vote_button")
        end
      end
    end
  end
end
