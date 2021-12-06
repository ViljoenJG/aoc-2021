defmodule AdventOfCode.Day06 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> parse_fishes()
    |> simulate_lanternfish(80)
  end

  def part2(args) do
    args
    |> parse_fishes()
    |> simulate_lanternfish(256)
  end

  defp parse_fishes(input) do
    input
    |> Utils.parse()
    # expecting only one line. Take only head (first line).
    |> hd
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp simulate_lanternfish(fishes, days) do
    fishes
    |> Enum.map(&{&1, 1})
    |> consolidate
    |> Stream.iterate(&next/1)
    |> Stream.drop(days)
    |> Enum.take(1)
    |> hd
    |> Enum.reduce(0, &(elem(&1, 1) + &2))
  end

  defp next(fish) do
    {fish, new} =
      Enum.map_reduce(fish, 0, fn {timer, n}, acc ->
        if timer == 0 do
          {{6, n}, acc + n}
        else
          {{timer - 1, n}, acc}
        end
      end)

    [{8, new} | fish]
    |> consolidate
  end

  defp consolidate(fish) do
    Enum.group_by(fish, &elem(&1, 0))
    |> Enum.map(fn {timer, counts} ->
      sum =
        Enum.map(counts, &elem(&1, 1))
        |> Enum.sum()

      {timer, sum}
    end)
  end
end
