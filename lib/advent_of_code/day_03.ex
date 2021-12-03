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
  end
end
