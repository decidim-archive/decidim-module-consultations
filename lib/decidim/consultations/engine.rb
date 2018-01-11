# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

module Decidim
  module Consultations
    # Decidim"s Consultations Rails Engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Consultations

      routes do
        get "/consultations/:consultation_id", to: redirect { |params, _request|
          consultation = Decidim::Consultation.find(params[:consultation_id])
          consultation ? "/consultations/#{initiative.slug}" : "/404"
        }, constraints: { consultation_id: /[0-9]+/ }

        get "/consultations/:consultation_id/f/:feature_id", to: redirect { |params, _request|
          consultation = Decidim::Consultation.find(params[:consultation_id])
          consultation ? "/consultation/#{consultation.slug}/f/#{params[:feature_id]}" : "/404"
        }, constraints: { consultation_id: /[0-9]+/ }

        resources :consultations, only: [:index, :show], param: :slug, path: "consultations" do
          # resource :consultation_widget, only: :show, path: "embed"
        end

        scope "/consultations/:consultation_slug/f/:feature_id" do
          Decidim.feature_manifests.each do |manifest|
            next unless manifest.engine

            constraints CurrentFeature.new(manifest) do
              mount manifest.engine, at: "/", as: "decidim_consultation_#{manifest.name}"
            end
          end
        end
      end

      # initializer "decidim_initiatives.assets" do |app|
      #   app.config.assets.precompile += %w(
      #     decidim_consultations_manifest.js
      #   )
      # end
      #
      initializer "decidim_consultations.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += %w(
            Decidim::Consultations::Abilities::EveryoneAbility
          )
        end
      end

      initializer "decidim.stats" do
        Decidim.stats.register :consultations_count, priority: StatsRegistry::HIGH_PRIORITY do |organization, _start_at, _end_at|
          Decidim::Consultation.where(organization: organization).published.count
        end
      end

      #
      # initializer "decidim_initiatives.view_hooks" do
      #   Decidim.view_hooks.register(:highlighted_elements, priority: Decidim::ViewHooks::MEDIUM_PRIORITY) do |view_context|
      #     highlighted_initiatives = OrganizationPrioritizedInitiatives.new(view_context.current_organization)
      #
      #     next unless highlighted_initiatives.any?
      #
      #     view_context.render(
      #       partial: "decidim/initiatives/pages/home/highlighted_initiatives",
      #       locals: {
      #         highlighted_initiatives: highlighted_initiatives
      #       }
      #     )
      #   end
      # end
      #
      initializer "decidim_consultations.menu" do
        Decidim.menu :menu do |menu|
          menu.item I18n.t("menu.consultations", scope: "decidim"),
                    decidim_consultations.consultations_path,
                    position: 2.7,
                    active: :inclusive
        end
      end
    end
  end
end
