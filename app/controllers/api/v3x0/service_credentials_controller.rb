module Api
  module V3x0
    class ServiceCredentialsController < ApplicationController
      include Mixins::IndexMixin
      include Api::V1::Mixins::ShowMixin
    end
  end
end

