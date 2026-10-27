defmodule LogParser do
  @moduledoc """
  Pure functions for counting log levels.
  No file access and no side effects: same input -> same output.
  """

  # Pure: counts lines containing the word ERROR / INFO
  def count_level(lines, level) do
    pattern = Regex.compile!("\\b" <> level <> "\\b")
    Enum.count(lines, fn line -> Regex.match?(pattern, line) end)
  end

  # Pure: returns {error_count, info_count}
  def count_levels(lines) do
    {count_level(lines, "ERROR"), count_level(lines, "INFO")}
  end

  # Pure: merges two result maps into a NEW map (inputs unchanged)
  def merge(a, b) do
    %{total_errors: a.total_errors + b.total_errors,
      total_infos: a.total_infos + b.total_infos}
  end
end
