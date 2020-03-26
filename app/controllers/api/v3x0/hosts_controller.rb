module Api
  module V3x0
    class HostsController < Api::V2x0::HostsController
      include Mixins::IndexMixin
    end
  end
end
