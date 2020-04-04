defmodule Renamer.Songs do
  def convert_to_map(csv_song_data) do
    csv_song_data
    |> Enum.reduce(%{}, fn {:ok, song}, acc ->
      Map.put(acc, song["info"], escaped_song_details(song))
    end)
  end

  def escaped_song_details(%{
        "disc" => disc,
        "track" => track,
        "artist" => artist,
        "title" => title,
        "info" => info
      }),
      do: %{
        "disc" => disc,
        "track" => track,
        "artist" => String.replace(artist, "/", ":"),
        "title" => String.replace(title, "/", ":"),
        "info" => info
      }

  def rename_songs(songs, source_folder, dest_folder, ext) do
    Renamer.Files.ls_r(source_folder)
    |> Enum.filter(&String.ends_with?(&1, ".#{ext}"))
    |> rename_song_files(songs, dest_folder)

    songs
  end

  defp rename_song_files(_files = [], _songs = %{}, _dest_folder), do: []

  defp rename_song_files(files = [_ | _], songs = %{}, dest_folder),
    do: files |> Enum.map(&rename_song_file(&1, songs, dest_folder))

  defp rename_song_file(source_path, songs = %{}, dest_folder) do
    source_path
    |> destination_path(songs, dest_folder)
    |> move_file_to(source_path)
  end

  defp destination_path(source_path, songs, dest_folder) do
    ext = source_path |> Path.extname() |> String.downcase()
    song_key = source_path |> Path.basename(ext) |> String.slice(-7..-1)
    relative_path = ext |> relative_file_path(songs[song_key])

    dest_folder <> relative_path
  end

  defp relative_file_path(
         ".bin",
         %{
           "disc" => disc,
           "track" => track,
           "artist" => artist,
           "title" => title,
           "info" => info
         }
       ),
       do: "/#{disc}/#{track} - #{artist} - #{title} - #{info}.bin"

  defp relative_file_path(
         ext,
         %{
           "artist" => artist,
           "title" => title,
           "info" => info
         }
       ),
       do: "/#{artist}/#{artist} - #{title} - #{info}#{ext}"

  defp move_file_to(destination, source) do
    create_directory(destination)
    source |> File.rename!(destination)
  end

  defp create_directory(destination_path) do
    destination_dir = Path.dirname(destination_path)
    unless File.dir?(destination_dir), do: File.mkdir_p!(destination_dir)
  end

  def list_missing_songs(csv_stream) do
    IO.puts("Start -- print missing songs")
    song_count = Enum.count(csv_stream)
    IO.inspect("#{song_count} songs being checked")
    csv_stream |> Enum.map(&print_missing_song(&1))
    IO.puts("End -- print missing songs")
  end

  defp print_missing_song(
         {:ok,
          %{
            "disc" => disc,
            "track" => track,
            "artist" => artist,
            "title" => title,
            "info" => info
          }}
       ) do
    folder = String.trim_trailing(artist, ".")

    bin_path =
      "/Volumes/media/Karaoke/Karaoke_bin/#{disc}/#{track} - #{artist} - #{title} - #{info}.bin"

    unless File.exists?(bin_path), do: IO.inspect("Missing: #{bin_path}")

    m4v_path = "/Volumes/media/Karaoke/Karaoke_m4v/#{folder}/#{artist} - #{title} - #{info}.m4v"
    unless File.exists?(m4v_path), do: IO.inspect("Missing: #{m4v_path}")

    mp3_path = "/Volumes/media/Karaoke/Karaoke_mp3/#{folder}/#{artist} - #{title} - #{info}.mp3"
    unless File.exists?(mp3_path), do: IO.inspect("Missing: #{mp3_path}")

    cdg_path = "/Volumes/media/Karaoke/Karaoke_mp3/#{folder}/#{artist} - #{title} - #{info}.cdg"
    unless File.exists?(cdg_path), do: IO.inspect("Missing: #{cdg_path}")
  end
end
