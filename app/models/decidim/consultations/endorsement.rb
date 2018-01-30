# frozen_string_literal: true

module Decidim
  module Consultations
    # The data store for question's endorsements in the Decidim::Consultations component.
    class Endorsement < ApplicationRecord
      include Authorable

      belongs_to :question,
                 foreign_key: "decidim_consultation_question_id",
                 class_name: "Decidim::Consultations::Question",
                 counter_cache: :endorsements_count,
                 inverse_of: :endorsements

      validates :author, uniqueness: { scope: [:decidim_user_group_id, :question] }

      delegate :organization, to: :question
    end
  end
end
