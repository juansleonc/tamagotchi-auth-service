# frozen_string_literal: true

module Mutations
  class Register < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(email:, password:, password_confirmation:)
      user = User.new(email:, password:, password_confirmation:)

      if user.save
        token = encode_token(user_id: user.id.to_s)
        {
          user:,
          token:,
          errors: []
        }
      else
        {
          user: nil,
          token: nil,
          errors: user.errors.full_messages
        }
      end
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
end
