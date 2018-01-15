# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/dev"

FactoryBot.define do
  sequence(:consultation_slug) do |n|
    "#{Faker::Internet.slug(nil, "-")}-#{n}"
  end

  factory :consultation, class: "Decidim::Consultation" do
    organization
    slug { generate(:consultation_slug) }
    title { Decidim::Faker::Localized.sentence(3) }
    subtitle { Decidim::Faker::Localized.sentence(1) }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    banner_image { Decidim::Dev.test_file("city2.jpeg", "image/jpeg") }
    published_at { Time.current }
    start_voting_date { Time.zone.today }
    introductory_video_url "https://www.youtube.com/embed/LakKJZjKkRM"
    decidim_highlighted_scope_id { create(:scope, organization: organization).id }

    trait :unpublished do
      published_at nil
    end

    trait :published do
      published_at { Time.current }
    end

    trait :upcoming do
      start_voting_date { Time.zone.today + 7.days }
    end

    trait :active do
      start_voting_date { Time.zone.today - 7.days }
    end
  end

  factory :question, class: "Decidim::Consultations::Question" do
    consultation
    scope { create(:scope, organization: consultation.organization) }

    title { Decidim::Faker::Localized.sentence(3) }
    subtitle { Decidim::Faker::Localized.sentence(3) }
    promoter_group { Decidim::Faker::Localized.sentence(3) }
    participatory_scope { Decidim::Faker::Localized.sentence(3) }
    question_context { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    what_is_decided { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    published_at { Time.current }
    introductory_video_url "https://www.youtube.com/embed/LakKJZjKkRM"
    banner_image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }

    trait :unpublished do
      published_at nil
    end

    trait :published do
      published_at { Time.current }
    end
  end
end
