defmodule AdventOfCode.Utils do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
  end

  def parse(input, sep, options \\ []) do
    input
    |> String.split(sep, options)
  end

  def parse_as_int(input) do
    input
    |> parse
    |> Enum.map(&String.to_integer/1)
  end

  def parse_as_int(input, sep, options \\ []) do
    input
    |> parse(sep, options)
    |> Enum.map(&String.to_integer/1)
  end
end
