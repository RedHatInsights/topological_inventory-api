module Api
  module V3x0
    class NetworksController < Api::V1::NetworksController
      include Mixins::IndexMixin
    end
  end
end
