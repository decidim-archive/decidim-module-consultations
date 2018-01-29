# frozen_string_literal: true

module Decidim
  module Consultations
    class Response < ApplicationRecord
      belongs_to :question,
                 foreign_key: "decidim_consultation_question_id",
                 class_name: "Decidim::Consultations::Question",
                 inverse_of: :responses
    end
  end
end
