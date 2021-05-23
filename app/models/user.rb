class User < ApplicationRecord
  include Users::Validatable

  scope :with_handle_id, -> (handle_id) {
    where(handle_id: handle_id)
  }
end
