defmodule AdventOfCode.Day03 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> Utils.parse()
    |> power_consumption
  end

  defp power_consumption(lines) do
    power_consumption(lines, initialise_significant_bits(lines))
  end

  defp initialise_significant_bits([line | _]) do
    line
    |> String.split("", trim: true)
    |> Enum.map(fn _ -> {0, 0} end)
  end

  defp power_consumption([line | lines], significant_bits) do
    significant_bits =
      line
      |> String.split("", trim: true)
      |> Enum.with_index(fn v, k -> {k, v} end)
      |> Enum.reduce(significant_bits, fn {i, bit}, acc ->
        List.update_at(acc, i, fn {a, b} ->
          case bit do
            "0" -> {a, b + 1}
            "1" -> {a + 1, b}
          end
        end)
      end)

    power_consumption(lines, significant_bits)
  end

  defp power_consumption([], significant_bits) do
    gamma = get_gamma(significant_bits)
    epsilon = get_epsilon(significant_bits)

    gamma * epsilon
  end

  defp get_gamma(significant_bits) do
    significant_bits
    |> Enum.map(fn {a, b} ->
      cond do
        a > b -> 1
        b > a -> 0
      end
    end)
    |> Integer.undigits(2)
  end

  defp get_epsilon(significant_bits) do
    significant_bits
    |> Enum.map(fn {a, b} ->
      cond do
        a > b -> 0
        b > a -> 1
      end
    end)
    |> Integer.undigits(2)
  end

  def part2(args) do
    input =
      args
      |> Utils.parse()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&List.to_tuple/1)

    oxygen_rating(input, 0) * co2_scrubber_rating(input, 0)
  end

  def oxygen_rating([elem], _pos), do: to_integer(elem)

  def oxygen_rating(input, pos) do
    groups = Enum.group_by(input, &elem(&1, pos))
    zeros_group = groups["0"] || []
    ones_group = groups["1"] || []

    if length(zeros_group) > length(ones_group) do
      oxygen_rating(zeros_group, pos + 1)
    else
      oxygen_rating(ones_group, pos + 1)
    end
  end

  def co2_scrubber_rating([elem], _pos), do: to_integer(elem)

  def co2_scrubber_rating(input, pos) do
    groups = Enum.group_by(input, &elem(&1, pos))
    zeros_group = groups["0"] || []
    ones_group = groups["1"] || []

    if length(ones_group) < length(zeros_group) do
      co2_scrubber_rating(ones_group, pos + 1)
    else
      co2_scrubber_rating(zeros_group, pos + 1)
    end
  end

  defp to_integer(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.join("")
    |> String.to_integer(2)
  end
end
