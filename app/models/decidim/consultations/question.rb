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

      delegate :organization, to: :consultation

      has_many :features, as: :participatory_space, dependent: :restrict_with_error

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

      def self.order_randomly(seed)
        transaction do
          connection.execute("SELECT setseed(#{connection.quote(seed)})")
          select('"decidim_consultations_questions".*, RANDOM()').order("RANDOM()").load
        end
      end
    end
  end
end
