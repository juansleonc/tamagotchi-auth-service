# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register, mutation: Mutations::Register
    field :login, mutation: Mutations::Login
  end
end
