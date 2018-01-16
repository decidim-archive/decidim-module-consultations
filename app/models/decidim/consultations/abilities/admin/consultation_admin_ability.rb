# frozen_string_literal: true

module Decidim
  module Consultations
    module Abilities
      module Admin
        # Defines the abilities related to user able to administer consultations.
        # Intended to be used with `cancancan`.
        class ConsultationAdminAbility
          include CanCan::Ability

          attr_reader :user, :context

          def initialize(user, context)
            return unless user&.admin?

            @user = user
            @context = context

            can :manage, Consultation
            can :manage, Question
          end
        end
      end
    end
  end
end
