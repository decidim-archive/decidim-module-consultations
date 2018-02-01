# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Consultations
    describe Endorsement do
      subject { endorsement }

      let(:endorsement) { build :endorsement }

      it { is_expected.to be_valid }
    end
  end
end
