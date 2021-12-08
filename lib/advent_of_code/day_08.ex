defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> parse()
    |> Enum.map(fn {_input, output} ->
      output
      |> Enum.map(&String.length/1)
      |> Enum.count(&(&1 in [2, 3, 4, 7]))
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.map(&determine_output/1)
    |> Enum.sum()
  end

  defp determine_output({input, output}) do
    output
    |> Enum.map(&determine_number(&1, input))
    |> Enum.join("")
    |> String.to_integer()
  end

  defp determine_number(code, input) do
    one = Enum.find(input, fn str -> String.length(str) == 2 end) |> String.to_charlist()
    four = Enum.find(input, fn str -> String.length(str) == 4 end) |> String.to_charlist()

    get_number(String.length(code), String.to_charlist(code), one, four)
  end

  defp get_number(len, chars, one, four)
  defp get_number(2, _, _, _), do: "1"
  defp get_number(3, _, _, _), do: "7"
  defp get_number(4, _, _, _), do: "4"
  defp get_number(7, _, _, _), do: "8"

  defp get_number(5, chars, one, four) do
    cond do
      length(chars -- one) == 3 -> "3"
      length(chars -- four) == 3 -> "2"
      true -> "5"
    end
  end

  defp get_number(6, chars, one, four) do
    cond do
      length(chars -- one) == 5 -> "6"
      length(chars -- four) == 2 -> "9"
      true -> "0"
    end
  end

  defp parse(args) do
    args
    |> Utils.parse()
    |> Enum.map(fn line ->
      [input, output] = String.split(line, " | ")
      {String.split(input), String.split(output)}
    end)
  end
end
