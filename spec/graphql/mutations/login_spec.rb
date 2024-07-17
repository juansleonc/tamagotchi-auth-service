# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Login, type: :request do
  describe 'login mutation' do
    let!(:user) do
      User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    end

    let(:query) do
      <<~GQL
        mutation Login($email: String!, $password: String!) {
          login(email: $email, password: $password) {
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

    it 'returns a token for valid credentials' do
      variables = {
        email: 'test@example.com',
        password: 'password123'
      }

      post '/graphql', params: { query:, variables: }

      json = JSON.parse(response.body)
      data = json['data']['login']

      expect(data['user']).to include(
        'email' => 'test@example.com'
      )
      expect(data['token']).to be_present
      expect(data['errors']).to be_empty
    end

    it 'returns an error for invalid credentials' do
      variables = {
        email: 'test@example.com',
        password: 'wrongpassword'
      }

      post '/graphql', params: { query:, variables: }

      json = JSON.parse(response.body)
      data = json['data']['login']

      expect(data['user']).to be_nil
      expect(data['token']).to be_nil
      expect(data['errors']).to include('Invalid email or password')
    end
  end
end
