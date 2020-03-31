defmodule Renamer.Files do
  def count_files(filepath) do
    count =
      filepath
      |> get_files()
      |> Enum.map(&extract_disc_info(&1))
      |> Enum.count()

    IO.inspect("#{filepath} contains: #{count} files")
  end

  defp get_files(filepath) do
    cond do
      String.contains?(filepath, ".git") -> []
      true -> expand(File.ls(filepath), filepath)
    end
  end

  defp expand({:ok, files}, path) do
    files
    |> Enum.flat_map(&get_files("#{path}/#{&1}"))
  end

  defp expand({:error, _}, path) do
    [path]
  end

  defp extract_disc_info(path) do
    length = String.length(path)
    path |> String.slice(length - 9, 5)
  end
end
