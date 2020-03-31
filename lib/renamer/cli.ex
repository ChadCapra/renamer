defmodule Renamer.CLI do
  def main(_args) do
    IO.puts("Me go boom boom in my panties!")

    # # rename newer songs
    # "songs.tsv"
    # |> Renamer.CSV.get_data()
    # |> Renamer.Songs.rename_songs()

    # list missing songs
    "all_songs.tsv"
    |> Renamer.CSV.get_data()
    |> Renamer.Songs.list_missing_songs()

    Renamer.Files.count_files("/Volumes/media/Karaoke/Karaoke_bin")
    Renamer.Files.count_files("/Volumes/media/Karaoke/Karaoke_m4v")
    Renamer.Files.count_files("/Volumes/media/Karaoke/Karaoke_mp3")
  end
end
