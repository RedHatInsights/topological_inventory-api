module Api
  module V0x1
    class ApplicationTypesController < ApplicationController
      include Api::V0x1::Mixins::IndexMixin
      include Api::V0::Mixins::ShowMixin
    end
  end
end
