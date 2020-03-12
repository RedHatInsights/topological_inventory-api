module Api
  module V3x0
    class NetworkAdaptersController < Api::V2x0::NetworkAdaptersController
      include Mixins::IndexMixin
    end
  end
end
