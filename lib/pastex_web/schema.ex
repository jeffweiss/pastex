defmodule PastexWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types PastexWeb.Schema.ContentTypes
  import_types PastexWeb.Schema.IdentityTypes

  query do
    field :health, :string do
      resolve(fn _, _, _ ->
        {:ok, "up"}
      end)
    end

    import_fields :content_queries
    import_fields :identity_queries
  end

  mutation do
    import_fields :content_mutations
    import_fields :identity_mutations
  end

  subscription do
    field :paste_created, :paste do
      arg :visibility, :string, default_value: "public"

      config fn %{visibility: visibility}, %{context: context} ->
        case {visibility, context} do
          {"public", _} ->
            {:ok, topic: "public"}

          {"private", %{current_user: %{id: user_id}}} ->
            {:ok, topic: "private:#{user_id}"}
          _ ->
            {:error, "unauthorized"}
        end
      end

      trigger :create_paste,
        topic: fn _paste ->
          "*"
        end
    end
  end

  def middleware(middleware, _field, _object) do
    # [PastexWeb.Middleware.AuthGet | middleware]
    tracing_middleware() ++ middleware ++ [PastexWeb.Middleware.AuthGet]
  end

  defp tracing_middleware() do
    [ApolloTracing.Middleware.Tracing]
  end
end
