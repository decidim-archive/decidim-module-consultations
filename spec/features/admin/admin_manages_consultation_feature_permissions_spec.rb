# frozen_string_literal: true

require "spec_helper"
require "decidim/admin/test/manage_feature_permissions_examples"

describe "Admin manages consultation feature permissions", type: :feature do
  include_examples "Managing feature permissions" do
    let(:participatory_space_engine) { decidim_admin_consultations }

    let!(:participatory_space) do
      create(:consultation, organization: organization)
    end
  end
end
