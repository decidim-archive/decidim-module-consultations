# frozen_string_literal: true

require "spec_helper"

describe "Admin manages questions", type: :feature do
  include_context "when administrating a consultation"

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_consultations.consultation_questions_path(consultation)
  end

  describe "creating a question" do
    before do
      click_link("New")
    end

    it "creates a new question" do
      within ".new_question" do
        fill_in_i18n(
          :question_title,
          "#question-title-tabs",
          en: "My question",
          es: "Mi pregunta",
          ca: "La meua pregunta"
        )
        fill_in_i18n(
          :question_subtitle,
          "#question-subtitle-tabs",
          en: "Subtitle",
          es: "Subtítulo",
          ca: "Subtítol"
        )
        fill_in_i18n(
          :question_promoter_group,
          "#question-promoter_group-tabs",
          en: "Promoter group",
          es: "Grupo promotor",
          ca: "Grup promotor"
        )
        fill_in_i18n(
          :question_participatory_scope,
          "#question-participatory_scope-tabs",
          en: "Participatory scope",
          es: "Ámbito participativo",
          ca: "Àmbit participatiu"
        )
        fill_in_i18n_editor(
          :question_question_context,
          "#question-question_context-tabs",
          en: "Context",
          es: "Contexto",
          ca: "Contexte"
        )
        fill_in_i18n_editor(
          :question_what_is_decided,
          "#question-what_is_decided-tabs",
          en: "What is decided",
          es: "Qué se decide",
          ca: "Què es decideix"
        )
        attach_file :question_banner_image, image2_path
        select2(translated(organization.scopes.first.name), from: :question_decidim_scope_id)

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_current_path decidim_admin_consultations.consultation_questions_path(consultation)
        expect(page).to have_content("My question")
      end
    end
  end

  describe "trying to create a question with invalid data" do
    before do
      click_link("New")
    end

    it "fails to create a new question" do
      within ".new_question" do
        fill_in_i18n(
          :question_title,
          "#question-title-tabs",
          en: "",
          es: "",
          ca: ""
        )
        fill_in_i18n(
          :question_subtitle,
          "#question-subtitle-tabs",
          en: "Subtitle",
          es: "Subtítulo",
          ca: "Subtítol"
        )
        fill_in_i18n(
          :question_promoter_group,
          "#question-promoter_group-tabs",
          en: "Promoter group",
          es: "Grupo promotor",
          ca: "Grup promotor"
        )
        fill_in_i18n(
          :question_participatory_scope,
          "#question-participatory_scope-tabs",
          en: "Participatory scope",
          es: "Ámbito participativo",
          ca: "Àmbit participatiu"
        )
        fill_in_i18n_editor(
          :question_question_context,
          "#question-question_context-tabs",
          en: "Context",
          es: "Contexto",
          ca: "Contexte"
        )
        fill_in_i18n_editor(
          :question_what_is_decided,
          "#question-what_is_decided-tabs",
          en: "What is decided",
          es: "Qué se decide",
          ca: "Què es decideix"
        )
        attach_file :question_banner_image, image2_path
        select2(translated(organization.scopes.first.name), from: :question_decidim_scope_id)

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("error")
    end
  end

  describe "updating a question" do
    before do
      click_link translated(question.title)
    end

    it "updates a question" do
      fill_in_i18n(
        :question_title,
        "#question-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )
      attach_file :question_banner_image, image3_path

      within ".edit_question" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within ".container" do
        expect(page).to have_selector("input[value='My new title']")
        expect(page).not_to have_css("img[src*='#{image2_filename}']")
        expect(page).to have_css("img[src*='#{image3_filename}']")
      end
    end
  end

  describe "updating a question with invalid values" do
    before do
      click_link translated(question.title)
    end

    it "do not updates the question" do
      fill_in_i18n(
        :question_title,
        "#question-title-tabs",
        en: "",
        es: "",
        ca: ""
      )

      within ".edit_question" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("error")
    end
  end

  describe "updating an question without images" do
    before do
      click_link translated(question.title)
    end

    it "update a question without images does not deletes them" do
      within ".edit_question" do
        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")
      expect(page).to have_css("img[src*='#{question.banner_image.url}']")
    end
  end

  describe "deleting a question" do
    before do
      click_link translated(question.title)
    end

    it "deletes the question" do
      accept_confirm { click_link "Destroy" }

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).not_to have_content(translated(question.title))
      end
    end
  end

  describe "previewing questions" do
    it "allows the user to preview the unpublished question" do
      within find("tr", text: translated(question.title)) do
        click_link "Preview"
      end

      expect(page).to have_content(translated(question.title))
    end
  end

  describe "viewing a missing question" do
    it_behaves_like "a 404 page" do
      let(:target_path) { decidim_admin_consultations.consultation_question_path(consultation, 99_999_999) }
    end
  end

  describe "publishing an consultation" do
    let!(:question) { create(:question, :unpublished, consultation: consultation) }

    before do
      click_link translated(question.title)
    end

    it "publishes the question" do
      click_link "Publish"
      expect(page).to have_content("published successfully")
      expect(page).to have_content("Unpublish")
      expect(page).to have_current_path decidim_admin_consultations.edit_consultation_question_path(consultation, question)

      question.reload
      expect(question).to be_published
    end
  end

  describe "unpublishing a question" do
    let!(:question) { create(:question, :published, consultation: consultation) }

    before do
      click_link translated(question.title)
    end

    it "unpublishes the question" do
      click_link "Unpublish"
      expect(page).to have_content("unpublished successfully")
      expect(page).to have_content("Publish")
      expect(page).to have_current_path decidim_admin_consultations.edit_consultation_question_path(consultation, question)

      question.reload
      expect(question).not_to be_published
    end
  end
end
