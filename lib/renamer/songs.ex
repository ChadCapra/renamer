defmodule Renamer.Songs do
  def rename_songs(csv_stream) do
    csv_stream |> Enum.map(&rename_song_files(&1))
  end

  defp rename_song_files(
         {:ok,
          %{
            "disc" => disc,
            "track" => track,
            "brand" => brand,
            "artist" => artist,
            "title" => title
          }}
       ) do
    track_pad = String.pad_leading(track, 2, "0")
    disc_info = "#{brand}#{disc}#{track_pad}"
    base_path = "/Users/chadcapra/dev"
    file_name = "#{artist} - #{title} - #{disc_info}"
    # Bin files
    bin_source = "#{base_path}/unorganized_bin/#{disc}_#{track_pad}.bin"
    bin_destination = "#{base_path}/Karaoke_bin/#{disc}/#{track} - #{file_name}.bin"

    bin_destination |> create_folder()
    bin_source |> move_file(bin_destination)

    # CDG/MP3
    cdg_source = "#{base_path}/unorganized_mp3/#{disc}_#{track_pad}.cdg"
    cdg_destination = "#{base_path}/Karaoke_mp3/#{artist}/#{file_name}.cdg"

    cdg_destination |> create_folder()
    cdg_source |> move_file(cdg_destination)

    mp3_source = "#{base_path}/unorganized_mp3/#{disc}_#{track_pad}.mp3"
    mp3_destination = "#{base_path}/Karaoke_mp3/#{artist}/#{file_name}.mp3"

    mp3_source |> move_file(mp3_destination)

    # M4V

    m4v_source = "#{base_path}/unorganized_m4v/#{disc}_#{track_pad}.m4v"
    m4v_destination = "#{base_path}/Karaoke_m4v/#{artist}/#{file_name}.m4v"
    m4v_destination |> create_folder()
    m4v_source |> move_file(m4v_destination)

    # IO.inspect("#{m4v_source} => #{m4v_destination}")
    # mp3_source |> File.rename!(mp3_destination)

    # m4v_source = "#{source_dir}/#{disc}_#{track}.m4v"
    # m4v_destination = "#{destination_dir}/#{artist} - #{title} - #{info}.m4v"
    # m4v_source |> File.rename!(m4v_destination)
  end

  defp create_folder(destination_file) do
    destination_dir = Path.dirname(destination_file)
    unless File.dir?(destination_dir), do: File.mkdir!(destination_dir)
  end

  defp move_file(source, destination) do
    IO.inspect("#{source} => #{destination}")
    source |> File.rename!(destination)
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
