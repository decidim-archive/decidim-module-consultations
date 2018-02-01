# frozen_string_literal: true

module Decidim
  module Consultations
    module Abilities
      # Defines the base abilities related to consultations and questions for
      # authenticated users. Intended to be used with `cancancan`.
      class CurrentUserAbility < Decidim::Abilities::EveryoneAbility
        attr_reader :user

        def initialize(user, context)
          super(user, context)
          return unless user

          @user = user

          can :endorse, Question do |question|
            can_endorse?(question)
          end

          can :unendorse, Question do |question|
            can_unendorse?(question)
          end
        end

        private

        def can_endorse?(question)
          question.organization.id == user.organization.id &&
            question.consultation.active? &&
            question.consultation.published? &&
            question.published? &&
            !question.endorsed_by?(user)
        end

        def can_unendorse?(question)
          question.consultation.active? &&
            question.consultation.published? &&
            question.published? &&
            question.endorsed_by?(user)
        end
      end
    end
  end
end
