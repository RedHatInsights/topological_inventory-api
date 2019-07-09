module Internal
  module V1
    class TenantsController < ::ApplicationController
      include Api::V1::Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
    end
  end
end
