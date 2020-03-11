module Api
  module V3x0
    class SecurityGroupsController < Api::V1::SecurityGroupsController
      include Mixins::IndexMixin
    end
  end
end
