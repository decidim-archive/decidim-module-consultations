# frozen_string_literal: true

module Decidim
  module Consultations
    # A controller that holds the logic to show consultations in a
    # public layout.
    class ConsultationsController < Decidim::ApplicationController
      layout "layouts/decidim/consultation", only: :show

      include NeedsConsultation
      include FilterResource
      include Paginable
      include Orderable

      helper_method :collection, :consultations, :filter

      helper Decidim::FiltersHelper
      helper Decidim::OrdersHelper
      helper Decidim::SanitizeHelper
      helper Decidim::PaginateHelper
      helper Decidim::IconHelper

      def index
        authorize! :read, Consultation

        if OrganizationConsultations.for(current_organization).published.count == 1
          redirect_to consultation_path(OrganizationConsultations.for(current_organization).published.first)
        end
      end

      def show
        authorize! :read, current_consultation
      end

      private

      def consultations
        @consultations = search.results
        @consultations = reorder(@consultations)
        @consultations = paginate(@consultations)
      end

      alias collection consultations

      def search_klass
        ConsultationSearch
      end

      def default_filter_params
        {
          search_text: "",
          state: "all"
        }
      end

      def context_params
        {
          organization: current_organization,
          current_user: current_user
        }
      end
    end
  end
end
