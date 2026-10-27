Code.require_file("log_parser.ex", __DIR__)
ExUnit.start()

defmodule LogParserTest do
  use ExUnit.Case

  test "counts ERROR lines" do
    lines = ["2026-10-26 ERROR disk full", "2026-10-26 INFO ok", "ERROR again"]
    assert LogParser.count_level(lines, "ERROR") == 2
  end

  test "counts INFO lines" do
    lines = ["INFO start", "INFO running", "ERROR crash"]
    assert LogParser.count_level(lines, "INFO") == 2
  end

  test "count_levels returns {errors, infos}" do
    assert LogParser.count_levels(["ERROR a", "INFO b", "INFO c"]) == {1, 2}
  end

  test "empty input gives zero" do
    assert LogParser.count_levels([]) == {0, 0}
  end

  test "does not count words that only contain ERROR" do
    assert LogParser.count_level(["TERRORISM report"], "ERROR") == 0
  end

  test "referential transparency: same input, same output" do
    lines = ["ERROR x", "INFO y"]
    assert LogParser.count_levels(lines) == LogParser.count_levels(lines)
  end

  test "merge returns a new map and does not change inputs" do
    a = %{total_errors: 1, total_infos: 2}
    b = %{total_errors: 3, total_infos: 4}
    assert LogParser.merge(a, b) == %{total_errors: 4, total_infos: 6}
    assert a == %{total_errors: 1, total_infos: 2}
  end
end
