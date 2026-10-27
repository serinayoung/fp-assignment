Code.require_file("log_parser.ex", __DIR__)

defmodule App do
  # Impure part: reads the file, then calls the PURE LogParser functions
  def worker(file, parent_pid) do
    case File.read(file) do
      {:ok, content} ->
        {errors, infos} = content |> String.split("\n", trim: true) |> LogParser.count_levels()
        send(parent_pid, {:result, file, errors, infos})

      {:error, reason} ->
        send(parent_pid, {:failed, file, reason})
    end
  end

  def start(files) do
    parent = self()

    Enum.each(files, fn f -> spawn(fn -> worker(f, parent) end) end)

    files
    |> Enum.map(fn _ ->
      receive do
        {:result, file, e, i} ->
          IO.puts("Done: #{file} (errors: #{e}, infos: #{i})")
          %{total_errors: e, total_infos: i}

        {:failed, file, reason} ->
          IO.puts("Failed: #{file} (#{reason})")
          %{total_errors: 0, total_infos: 0}
      end
    end)
    |> Enum.reduce(%{total_errors: 0, total_infos: 0}, &LogParser.merge(&2, &1))
    |> IO.inspect(label: "Final Result")
  end
end

files =
  case System.argv() do
    [] -> ["log1.txt", "log2.txt", "log3.txt", "log4.txt", "log5.txt"]
    args -> args
  end

App.start(files)
