# frozen_string_literal: true

module Decidim
  module Consultations
    # The data store for question's votes in the Decidim::Consultations component.
    class Vote < ApplicationRecord
      belongs_to :question,
                 foreign_key: "decidim_consultation_question_id",
                 class_name: "Decidim::Consultations::Question",
                 counter_cache: :votes_count,
                 inverse_of: :votes

      belongs_to :author,
                 foreign_key: "decidim_author_id",
                 class_name: "Decidim::User"

      validates :author, uniqueness: { scope: [:question] }
    end
  end
end