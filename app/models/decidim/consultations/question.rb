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

      belongs_to :consultation,
                 foreign_key: "decidim_consultation_id",
                 class_name: "Decidim::Consultation"

      delegate :organization, to: :consultation

      has_many :features, as: :participatory_space, dependent: :restrict_with_error

      scope :upcoming, -> { published.where("start_voting_date > ?", Time.now.utc) }
      scope :finished, -> { published.where("end_voting_date <= ?", Time.now.utc) }
      scope :active, lambda {
        published
          .where("start_voting_date <= ?", Time.now.utc)
          .where("end_voting_date > ?", Time.now.utc)
      }
      scope :order_by_most_recent, -> { order(created_at: :desc) }

      def upcoming?
        start_voting_date > Time.now.utc
      end

      def finished?
        end_voting_date <= Time.now.utc
      end

      def active?
        start_voting_date <= Time.now.utc && end_voting_date > Time.now.utc
      end

      # Public: Overrides the `comments_have_alignment?` Commentable concern method.
      def comments_have_alignment?
        true
      end

      # Public: Overrides the `comments_have_votes?` Commentable concern method.
      def comments_have_votes?
        true
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
