module Users
  module Validatable
    extend ActiveSupport::Concern

    included do
      validates_uniqueness_of :handle_id, on: :create  # Handle ID has to be unique to be able to login the correct user.
      validates_presence_of :handle_id, :encrypted_password
    end
  end
end
