class AuthServiceSchema < GraphQL::Schema
  include ApolloFederation::Schema

  use ApolloFederation::Tracing

  query(Types::QueryType)
  mutation(Types::MutationType)
end
