# frozen_string_literal: true

class AddSlugToDecidimConsultationsQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_consultations_questions, :slug, :string

    Decidim::Consultations::Question.find_each do |question|
      question.slug = "q-#{question.id}"
      question.save
    end

    change_column_null :decidim_consultations_questions, :slug, false

    add_index :decidim_consultations_questions,
              [:decidim_consultation_id, :slug],
              name: "index_unique_question_slug_and_consultation",
              unique: true
  end
end
