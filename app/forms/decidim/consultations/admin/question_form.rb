# frozen_string_literal: true

module Decidim
  module Consultations
    module Admin
      # A form object used to create questions for a consultation from the admin dashboard.
      class QuestionForm < Form
        include TranslatableAttributes

        mimic :question

        translatable_attribute :title, String
        translatable_attribute :promoter_group, String
        translatable_attribute :participatory_scope, String
        translatable_attribute :question_context, String
        translatable_attribute :subtitle, String
        translatable_attribute :what_is_decided, String
        attribute :slug, String
        attribute :introductory_video_url, String
        attribute :banner_image
        attribute :remove_banner_image
        attribute :hashtag, String
        attribute :decidim_scope_id, Integer

        validates :slug, presence: true, format: { with: Decidim::Consultations::Question.slug_format }
        validates :title, :promoter_group, :participatory_scope, :subtitle, :what_is_decided, translatable_presence: true
        validates :decidim_scope_id, presence: true
        validates :banner_image, file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } }, file_content_type: { allow: ["image/jpeg", "image/png"] }
        validate :slug_uniqueness

        private

        def slug_uniqueness
          return unless OrganizationQuestions
                        .new(current_organization)
                        .query
                        .where(slug: slug)
                        .where.not(id: context[:question_id]).any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
