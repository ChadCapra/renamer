defmodule Renamer.CLI do
  def main(_args) do
    bin_source = "/Volumes/media/Karaoke/karaoke_cds"
    bin_destination = "/Volumes/media/Karaoke/karaoke_cds"

    mp3_source = "/Volumes/media/Karaoke/karaoke_mp3s"
    mp3_destination = "/Volumes/media/Karaoke/karaoke_mp3s"

    m4v_source = "/Volumes/media/Karaoke/karaoke_vids"
    m4v_destination = "/Volumes/media/Karaoke/karaoke_vids"

    # rename newer songs
    songs =
      "songs.tsv"
      |> Renamer.CSV.get_data()
      |> Renamer.Songs.convert_to_map()
      |> IO.inspect()

    Renamer.Songs.rename_songs(songs, bin_source, bin_destination, "bin")
    Renamer.Songs.rename_songs(songs, mp3_source, mp3_destination, "mp3")
    Renamer.Songs.rename_songs(songs, mp3_source, mp3_destination, "cdg")
    Renamer.Songs.rename_songs(songs, m4v_source, m4v_destination, "m4v")
  end
end
