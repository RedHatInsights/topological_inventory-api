module Api
  module V3x0
    class NetworkAdaptersController < Api::V1::NetworkAdaptersController
      include Mixins::IndexMixin
    end
  end
end
