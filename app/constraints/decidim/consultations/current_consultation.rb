# frozen_string_literal: true

module Decidim
  module Consultations
    # This class infers the current consultation we're scoped to by
    # looking at the request parameters and the organization in the request
    # environment, and injects it into the environment.
    class CurrentConsultation
      # Public: Matches the request against a consultation and injects it
      #         into the environment.
      #
      # request - The request that holds the consultation relevant
      #           information.
      #
      # Returns a true if the request matched, false otherwise
      def matches?(request)
        env = request.env

        @organization = env["decidim.current_organization"]
        return false unless @organization

        current_consultation(env, request.params) ? true : false
      end

      private

      def current_consultation(env, params)
        env["decidim.current_participatory_space"] ||=
          detect_current_consultation(params)
      end

      def detect_current_consultation(params)
        organization_consultations.where(slug: params["consultation_slug"]).or(
          organization_consultations.where(id: params["consultation_id"])
        ).first!
      end

      def organization_consultations
        @organization_consultations ||= OrganizationConsultations.for(@organization)
      end
    end
  end
end
