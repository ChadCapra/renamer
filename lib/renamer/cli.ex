defmodule Renamer.CLI do
  def main(_args) do
    IO.puts("Me go boom boom in my panties!")

    "songs.tsv"
    |> Renamer.CSV.get_data()
    |> Renamer.Songs.rename_songs()
  end
end
