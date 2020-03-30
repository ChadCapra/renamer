defmodule Renamer.CSV do
  def get_data(path) do
    path
    |> Path.expand(File.cwd!())
    |> File.stream!()
    |> CSV.decode(separator: ?\t, headers: true)
  end
end
