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
          consultation ? "/consultations/#{consultation.slug}" : "/404"
        }, constraints: { consultation_id: /[0-9]+/ }

        get "/questions/:question_id", to: redirect { |params, _request|
          question = Decidim::Consultations::Question.find(params[:question_id])
          question ? "/questions/#{question.slug}" : "/404"
        }, constraints: { question_id: /[0-9]+/ }

        resources :consultations, only: [:index, :show], param: :slug, path: "consultations" do
          get "finished", on: :collection

          resources :questions, only: [:show], param: :slug, path: "questions", shallow: true do
            get "technical_info", on: :member
            resource :question_widget, only: :show, path: "embed"
            resource :question_votes, only: [:create, :destroy], path: "vote"
          end
        end

        get "/questions/:question_id/f/:feature_id", to: redirect { |params, _request|
          consultation = Decidim::Consultations::Question.find(params[:question_id])
          consultation ? "/questions/#{question.slug}/f/#{params[:feature_id]}" : "/404"
        }, constraints: { question_id: /[0-9]+/ }

        scope "/questions/:question_slug/f/:feature_id" do
          Decidim.feature_manifests.each do |manifest|
            next unless manifest.engine

            constraints CurrentFeature.new(manifest) do
              mount manifest.engine, at: "/", as: "decidim_question_#{manifest.name}"
            end
          end
        end
      end

      initializer "decidim_consultations.assets" do |app|
        app.config.assets.precompile += %w(
          decidim_consultations_manifest.css
          decidim_consultations_manifest.js
        )
      end

      initializer "decidim_consultations.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += %w(
            Decidim::Consultations::Abilities::EveryoneAbility
            Decidim::Consultations::Abilities::CurrentUserAbility
          )
        end
      end

      initializer "decidim.stats" do
        Decidim.stats.register :consultations_count, priority: StatsRegistry::HIGH_PRIORITY do |organization, _start_at, _end_at|
          Decidim::Consultation.where(organization: organization).published.count
        end
      end

      initializer "decidim_consultations.view_hooks" do
        Decidim.view_hooks.register(:highlighted_elements, priority: Decidim::ViewHooks::HIGH_PRIORITY) do |view_context|
          consultations = OrganizationActiveConsultations
                          .for(view_context.current_organization)
                          .where(enable_highlighted_banner: true)
          next unless consultations.any?

          view_context.render(
            partial: "decidim/consultations/pages/home/active_consultation",
            locals: {
              consultation: consultations.first
            }
          )
        end
      end

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
