defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> String.trim()
    |> Utils.parse_as_int(",", trim: true)
    |> then(fn x ->
      min = Enum.min(x)
      max = Enum.max(x)

      min..max
      |> Enum.map(fn y ->
        x
        |> Enum.map(&abs(y - &1))
        |> Enum.sum()
      end)
    end)
    |> Enum.min()
  end

  def part2(args) do
    f = fn n -> n * (n + 1) / 2 end

    args
    |> String.trim()
    |> Utils.parse_as_int(",", trim: true)
    |> then(fn x ->
      min = Enum.min(x)
      max = Enum.max(x)

      min..max
      |> Enum.map(fn y ->
        x
        |> Enum.map(&f.(abs(y - &1)))
        |> Enum.sum()
      end)
    end)
    |> Enum.min()
  end
end
