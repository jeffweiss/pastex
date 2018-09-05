defmodule Pastex.Content.Paste do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pastes" do
    field :description, :string
    field :name, :string
    field :visibility, :string, null: false, default: "public"

    belongs_to :author, Pastex.Identity.User

    has_many :files, Pastex.Content.File

    timestamps()
  end

  @doc false
  def changeset(paste, attrs) do
    paste
    |> cast(attrs, [:author_id, :name, :description, :visibility])
    |> cast_assoc(:files)
    |> validate_required([:name, :description])
  end
end
