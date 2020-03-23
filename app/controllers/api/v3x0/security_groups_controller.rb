module Api
  module V3x0
    class SecurityGroupsController < Api::V2x0::SecurityGroupsController
      include Mixins::IndexMixin
    end
  end
end
