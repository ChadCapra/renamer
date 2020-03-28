IO.puts("Hello world!")

"songs.tsv"
|> Renamer.Rename.start()

# |> Path.expand(__DIR__)
# |> File.stream!()
# |> CSV.decode()
# |> take_20()
# |> IO.inspect()
