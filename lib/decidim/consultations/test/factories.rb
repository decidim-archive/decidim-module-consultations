# frozen_string_literal: true

require "decidim/faker/localized"
require "decidim/dev"

FactoryBot.define do
  sequence(:consultation_slug) do |n|
    "#{Faker::Internet.slug(nil, "-")}-#{n}"
  end

  sequence(:question_slug) do |n|
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
    start_endorsing_date { Time.zone.today }
    end_endorsing_date { Time.zone.today + 1.month }
    introductory_video_url "https://www.youtube.com/embed/LakKJZjKkRM"
    decidim_highlighted_scope_id { create(:scope, organization: organization).id }
    enable_highlighted_banner true

    trait :unpublished do
      published_at nil
    end

    trait :published do
      published_at { Time.current }
    end

    trait :upcoming do
      start_endorsing_date { Time.zone.today + 7.days }
      end_endorsing_date { Time.zone.today + 1.month + 7.days }
    end

    trait :active do
      start_endorsing_date { Time.zone.today - 7.days }
      end_endorsing_date { Time.zone.today - 7.days + 1.month }
    end

    trait :finished do
      start_endorsing_date { Time.zone.today - 7.days - 1.month }
      end_endorsing_date { Time.zone.today - 7.days }
    end

    trait :banner_disabled do
      enable_highlighted_banner false
    end

    trait :banner_enabled do
      enable_highlighted_banner true
    end
  end

  factory :question, class: "Decidim::Consultations::Question" do
    consultation
    organization { consultation.organization }
    scope { create(:scope, organization: consultation.organization) }
    slug { generate(:question_slug) }
    title { Decidim::Faker::Localized.sentence(3) }
    subtitle { Decidim::Faker::Localized.sentence(3) }
    promoter_group { Decidim::Faker::Localized.sentence(3) }
    participatory_scope { Decidim::Faker::Localized.sentence(3) }
    question_context { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    what_is_decided { Decidim::Faker::Localized.wrapped("<p>", "</p>") { Decidim::Faker::Localized.sentence(4) } }
    published_at { Time.current }
    introductory_video_url "https://www.youtube.com/embed/LakKJZjKkRM"
    banner_image { Decidim::Dev.test_file("city.jpeg", "image/jpeg") }
    external_endorsement false

    trait :unpublished do
      published_at nil
    end

    trait :published do
      published_at { Time.current }
    end

    trait :external_endorsement do
      external_endorsement true
      i_frame_url "http://example.org"
    end
  end

  factory :response, class: "Decidim::Consultations::Response" do
    question
    title { Decidim::Faker::Localized.sentence(3) }
  end

  factory :endorsement, class: "Decidim::Consultations::Endorsement" do
    question
    author { create(:user, organization: question.organization) }
  end
end
