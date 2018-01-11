# frozen_string_literal: true

Decidim.register_participatory_space(:consultations) do |participatory_space|
  participatory_space.engine = Decidim::Consultations::Engine
  participatory_space.admin_engine = Decidim::Consultations::AdminEngine
  # participatory_space.icon = "decidim/assemblies/icon.svg"
  participatory_space.model_class_name = "Decidim::Consultation"

  participatory_space.seeds do
    seeds_root = File.join(__dir__, "..", "..", "..", "db", "seeds")
    organization = Decidim::Organization.first

    3.times do
      Decidim::Consultation.create!(
        slug: Faker::Internet.unique.slug(nil, "-"),
        title: Decidim::Faker::Localized.sentence(3),
        subtitle: Decidim::Faker::Localized.sentence(3),
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        published_at: Time.now.utc,
        start_voting_date: Time.zone.today,
        banner_image: File.new(File.join(seeds_root, "city2.jpeg")),
        introductory_video_url: "https://www.youtube.com/embed/LakKJZjKkRM",
        decidim_highlighted_scope_id: Decidim::Scope.reorder("RANDOM()").first.id,
        organization: organization
      )
    end
  end
end
