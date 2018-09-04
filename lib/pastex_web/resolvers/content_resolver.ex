defmodule PastexWeb.ContentResolver do
  alias Pastex.Content

  def list_pastes(_, _, _) do
    {:ok, Content.list_pastes()}
  end

  def get_files(paste, _, _) do
    files =
      paste
      |> Ecto.assoc(:files)
      |> Pastex.Repo.all()

    {:ok, files}
  end

  def format_body(file, arguments, _) do
    case arguments do
      %{style: :formatted} ->
        {:ok, Code.format_string!(file.body)}

      _ ->
        {:ok, file.body}
    end
  end
end
