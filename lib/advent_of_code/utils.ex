defmodule AdventOfCode.Utils do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
  end

  def parse_as_int(input) do
    input
    |> parse
    |> Enum.map(&String.to_integer/1)
  end
end
