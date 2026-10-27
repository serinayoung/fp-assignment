# Sequential vs Concurrent timing (Member 4 - Yani)
# Run from the project folder (same folder as log_parser.ex):
#   elixir compare.exs                       (uses logs/server_*.log)
#   elixir compare.exs logs/server_1.log ... (or give your own files)

Code.require_file("log_parser.ex", __DIR__)

defmodule Compare do
  def count_file(file) do
    file |> File.read!() |> String.split("\n", trim: true) |> LogParser.count_levels()
  end

  # One file after another, in a single process
  def sequential(files), do: files |> Enum.map(&count_file/1) |> merge()

  # One process per file, all at the same time
  def concurrent(files) do
    parent = self()
    Enum.each(files, fn f -> spawn(fn -> send(parent, {:done, count_file(f)}) end) end)

    files
    |> Enum.map(fn _ ->
      receive do
        {:done, r} -> r
      end
    end)
    |> merge()
  end

  defp merge(results) do
    Enum.reduce(results, %{total_errors: 0, total_infos: 0}, fn {e, i}, acc ->
      LogParser.merge(acc, %{total_errors: e, total_infos: i})
    end)
  end
end

files =
  case System.argv() do
    [] -> Path.wildcard("logs/server_*.log") |> Enum.sort()
    args -> args
  end

if files == [], do: raise("No log files found. Run: elixir log_generator.exs")

IO.puts("Files: #{length(files)} | CPU cores (schedulers): #{System.schedulers_online()}")

{t_seq, r_seq} = :timer.tc(fn -> Compare.sequential(files) end)
IO.puts("Sequential : #{div(t_seq, 1000)} ms  -> #{inspect(r_seq)}")

{t_con, r_con} = :timer.tc(fn -> Compare.concurrent(files) end)
IO.puts("Concurrent : #{div(t_con, 1000)} ms  -> #{inspect(r_con)}")

IO.puts("Same result? #{r_seq == r_con}")
IO.puts("Speedup    : #{Float.round(t_seq / max(t_con, 1), 2)}x faster")
