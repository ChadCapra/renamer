defmodule Renamer.CLI do
  def main(_args) do
    IO.puts("Me go boom boom in my panties!")

    # # rename newer songs
    # "songs.tsv"
    # |> Renamer.CSV.get_data()
    # |> Renamer.Songs.rename_songs()

    bin_source = "/Volumes/media/Karaoke/test_bin"
    bin_destination = "/Volumes/media/Karaoke/Karaoke CDs"

    mp3_source = "/Volumes/media/Karaoke/test_mp3"
    mp3_destination = "/Volumes/media/Karaoke/Karaoke Mp3s"

    m4v_source = "/Volumes/media/Karaoke/test_m4v"
    m4v_destination = "/Volumes/media/Karaoke/Karaoke Vids"

    # list missing songs
    "songs.tsv"
    |> Renamer.CSV.get_data()
    |> Renamer.Songs.convert_to_map()
    |> Renamer.Songs.rename_songs(bin_source, bin_destination, "bin")
    |> Renamer.Songs.rename_songs(mp3_source, mp3_destination, "mp3")
    |> Renamer.Songs.rename_songs(mp3_source, mp3_destination, "cdg")
    |> Renamer.Songs.rename_songs(m4v_source, m4v_destination, "m4v")
  end
end
