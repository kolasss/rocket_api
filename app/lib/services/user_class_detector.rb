# frozen_string_literal: true

module Services
  class UserClassDetector
    CLASSES = {
      'supervisor' => ::Users::Supervisor,
      'courier' => ::Users::Courier,
      'admin' => ::Users::Admin,
      'shop_manager' => ::Users::ShopManager,
      'client' => ::Users::Client
    }.freeze

    def common_class(role)
      CLASSES.except('client')[role]
    end
  end
end
