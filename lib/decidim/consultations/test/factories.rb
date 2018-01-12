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
    introductory_video_url "https://www.youtube.com/watch?v=OB5SS3wCZx0"
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
    decidim_scope { create(:scope, organization: consultation.organization) }

    title { Decidim::Faker::Localized.sentence(3) }
    promoter_group { Decidim::Faker::Localized.sentence(3) }
    participatory_scope { Decidim::Faker::Localized.sentence(3) }
    context { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    published_at { Time.current }
    start_voting_date { Time.current }
    end_voting_date { start_voting_date + 2.months }
    introductory_video_url "https://www.youtube.com/watch?v=OB5SS3wCZx0"

    trait :unpublished do
      published_at nil
    end

    trait :published do
      published_at { Time.current }
    end

    trait :upcoming do
      start_voting_date { Time.current + 1.day }
      end_voting_date { start_voting_date + 2.months }
    end

    trait :active do
      start_voting_date { Time.current - 15.days }
      end_voting_date { start_voting_date + 15.days }
    end

    trait :finished do
      start_voting_date { Time.current - 3.months }
      end_voting_date { start_voting_date + 2.months }
    end
  end
end
