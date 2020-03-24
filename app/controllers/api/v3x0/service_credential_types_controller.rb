module Api
  module V3x0
    class ServiceCredentialTypesController < ApplicationController
      include Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
    end
  end
end

