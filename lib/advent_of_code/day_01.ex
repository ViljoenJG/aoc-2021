defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> Utils.parse_as_int()
    |> p1_increasing()
  end

  def part2(args) do
    args
    |> Utils.parse_as_int()
    |> p2_increasing
  end

  # Part One

  defp p1_increasing([a, b | t]) when b > a do
    1 + p1_increasing([b | t])
  end

  defp p1_increasing([_, b | t]), do: p1_increasing([b | t])

  defp p1_increasing(_), do: 0

  # Part two

  defp p2_increasing(input), do: p2_increasing(input, :infinity, 0)

  defp p2_increasing([a, b, c | t], prev, acc) do
    sum = a + b + c

    if sum > prev do
      p2_increasing([b, c | t], sum, acc + 1)
    else
      p2_increasing([b, c | t], sum, acc)
    end
  end

  defp p2_increasing([_ | _], _prev, acc), do: acc
end
