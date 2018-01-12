# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Consultations
    # Overrides some scopeable module methods. Consultations are not intended to be scopeable
    module OverrideScopeable
      extend ActiveSupport::Concern

      included do
        def subscopes
          organization.top_scopes
        end

        def has_subscopes?
          subscopes.any?
        end
      end
    end
  end
end