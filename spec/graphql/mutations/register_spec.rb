require 'rails_helper'

RSpec.describe Mutations::Register, type: :request do
  describe 'register mutation' do
    let(:query) do
      <<~GQL
        mutation Register($email: String!, $password: String!, $passwordConfirmation: String!) {
          register(email: $email, password: $password, passwordConfirmation: $passwordConfirmation) {
            user {
              id
              email
            }
            token
            errors
          }
        }
      GQL
    end

    it 'creates a new user' do
      variables = {
        email: 'test@example.com',
        password: 'password123',
        passwordConfirmation: 'password123'
      }

      post '/graphql', params: { query: query, variables: variables }

      json = JSON.parse(response.body)
      data = json['data']['register']

      expect(data['user']).to include(
        'email' => 'test@example.com'
      )
      expect(data['token']).to be_present
      expect(data['errors']).to be_empty
    end

    it 'returns errors for invalid input' do
      variables = {
        email: 'invalid-email',
        password: 'short',
        passwordConfirmation: 'short'
      }

      post '/graphql', params: { query: query, variables: variables }

      json = JSON.parse(response.body)
      data = json['data']['register']

      expect(data['user']).to be_nil
      expect(data['token']).to be_nil
      expect(data['errors']).to include(
        "Email is invalid",
        "Password is too short (minimum is 6 characters)"
      )
    end
  end
end
