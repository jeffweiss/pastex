defmodule PastexWeb.Schema do
  use Absinthe.Schema

  alias PastexWeb.ContentResolver

  import_types PastexWeb.Schema.ContentTypes

  query do
    field :health, :string do
      resolve(fn _, _, _ ->
        IO.puts "Executing Health"
        {:ok, "up"}
      end)
    end

    field :pastes, list_of(:paste) do
      resolve &ContentResolver.list_pastes/3
    end
  end

end
