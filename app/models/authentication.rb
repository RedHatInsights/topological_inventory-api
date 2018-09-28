class Authentication < ApplicationRecord
  include PasswordConcern
  encrypt_column :password

  belongs_to :resource, :polymorphic => true
end
