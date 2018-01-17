# frozen_string_literal: true

module Decidim
  module Consultations
    # The data store for Consultation questions in the Decidim::Consultations component.
    class Question < ApplicationRecord
      include Decidim::Participable
      include Decidim::Publicable
      include Decidim::Scopable
      include Decidim::Comments::Commentable
      include Decidim::Followable
      include Decidim::HasAttachments
      include Decidim::Consultations::OverrideCategorization

      belongs_to :consultation,
                 foreign_key: "decidim_consultation_id",
                 class_name: "Decidim::Consultation"

      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"

      has_many :features, as: :participatory_space, dependent: :destroy

      mount_uploader :banner_image, Decidim::BannerImageUploader

      scope :order_by_most_recent, -> { order(created_at: :desc) }

      # Public: Overrides the `comments_have_alignment?` Commentable concern method.
      def comments_have_alignment?
        true
      end

      # Public: Overrides the `comments_have_votes?` Commentable concern method.
      def comments_have_votes?
        true
      end

      def hashtag
        attributes["hashtag"].to_s.delete("#")
      end

      def banner_image_url
        banner_image.present? ? banner_image.url : consultation.banner_image.url
      end

      def self.order_randomly(seed)
        transaction do
          connection.execute("SELECT setseed(#{connection.quote(seed)})")
          select('"decidim_consultations_questions".*, RANDOM()').order("RANDOM()").load
        end
      end

      def scopes_enabled?
        false
      end

      def scopes_enabled
        false
      end

      def to_param
        slug
      end

      # Overrides module name from participable concern
      def module_name
        "Decidim::Consultations"
      end

      def mounted_engine
        "decidim_consultations"
      end

      def mounted_admin_engine
        "decidim_admin_consultations"
      end

      def self.participatory_space_manifest
        Decidim.find_participatory_space_manifest(Decidim::Consultation.name.demodulize.underscore.pluralize)
      end
    end
  end
end
