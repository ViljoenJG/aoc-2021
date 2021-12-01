defmodule AdventOfCode.Utils do
  def parse(input) do
    input
    |> String.trim()
    |> String.trim("\n")
    |> String.split("\n")
  end

  def parse_as_int(input) do
    input
    |> parse
    |> Enum.map(&String.to_integer/1)
  end
end
