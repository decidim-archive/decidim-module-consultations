# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    module Admin
      describe QuestionForm do
        subject do
          described_class
            .from_params(attributes)
            .with_context(
              current_organization: organization,
              current_consultation: consultation
            )
        end

        let(:organization) { create :organization }
        let(:consultation) { create :consultation, organization: organization }
        let(:scope) { create :scope, organization: organization }
        let(:title) do
          {
            en: "Title",
            es: "Título",
            ca: "Títol"
          }
        end
        let(:subtitle) do
          {
            en: "Subtitle",
            es: "Subtítulo",
            ca: "Subtítol"
          }
        end
        let(:promoter_group) do
          {
            en: "Promoter group",
            es: "Grupo promotor",
            ca: "Grup promotor"
          }
        end
        let(:participatory_scope) do
          {
            en: "Participatory scope",
            es: "Ámbito participativo",
            ca: "Àmbit participatiu"
          }
        end
        let(:what_is_decided) do
          {
            en: "What is decided",
            es: "Qué se decide",
            ca: "Què es decideix"
          }
        end
        let(:attachment) { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
        let(:attributes) do
          {
            "question" => {
              "title_en" => title[:en],
              "title_es" => title[:es],
              "title_ca" => title[:ca],
              "subtitle_en" => subtitle[:en],
              "subtitle_es" => subtitle[:es],
              "subtitle_ca" => subtitle[:ca],
              "promoter_group_en" => promoter_group[:en],
              "promoter_group_es" => promoter_group[:es],
              "promoter_group_ca" => promoter_group[:ca],
              "participatory_scope_en" => participatory_scope[:en],
              "participatory_scope_es" => participatory_scope[:es],
              "participatory_scope_ca" => participatory_scope[:ca],
              "what_is_decided_en" => what_is_decided[:en],
              "what_is_decided_es" => what_is_decided[:es],
              "what_is_decided_ca" => what_is_decided[:ca],
              "decidim_scope_id" => scope&.id,
              "banner_image" => attachment
            }
          }
        end

        before do
          Decidim::AttachmentUploader.enable_processing = true
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when banner_image is too big" do
          before do
            allow(Decidim).to receive(:maximum_attachment_size).and_return(5.megabytes)
            expect(subject.banner_image).to receive(:size).and_return(6.megabytes)
          end

          it { is_expected.not_to be_valid }
        end

        context "when images are not the expected type" do
          let(:attachment) { Decidim::Dev.test_file("Exampledocument.pdf", "application/pdf") }

          it { is_expected.not_to be_valid }
        end

        context "when default language in title is missing" do
          let(:title) do
            { ca: "Títol" }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in subtitle is missing" do
          let(:subtitle) do
            { ca: "Subtítol" }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in promoter group is missing" do
          let(:promoter_group) do
            { ca: "Grup promotor" }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in participatory scope is missing" do
          let(:participatory_scope) do
            { ca: "Àmbit participatiu" }
          end

          it { is_expected.to be_invalid }
        end

        context "when default language in what is decided is missing" do
          let(:what_is_decided) do
            { ca: "Què es decideix" }
          end

          it { is_expected.to be_invalid }
        end

        context "when scope is missing" do
          let(:scope) { nil }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
