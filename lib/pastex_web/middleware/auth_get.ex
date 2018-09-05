defmodule PastexWeb.Middleware.AuthGet do
  @behaviour Absinthe.Middleware

  alias Pastex.Identity

  def call(resolution, _) do
    entity = resolution.source
    schema_node = resolution.definition.schema_node
    key = schema_node.identifier
    current_user = resolution.context[:current_user]

    if Identity.authorized?(entity, key, current_user) do
      resolution
    else
      auth_result = Absinthe.Type.meta(schema_node, :auth)
      error_or_nil = if auth_result == :use_nil do
        {:ok, nil}
      else
        {:error, "unauthorized"}
      end
      Absinthe.Resolution.put_result(resolution, error_or_nil)
    end
  end
end
