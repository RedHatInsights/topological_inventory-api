module Api
  module V3x0
    class HostsController < Api::V1::HostsController
      include Mixins::IndexMixin
    end
  end
end
