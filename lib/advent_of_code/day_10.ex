defmodule AdventOfCode.Day10 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> get_char_list()
    |> Enum.reduce(0, fn line, acc ->
      case find_errors(line) do
        {:incomplete, _} -> acc
        {:corrupted, char} -> acc + corrupted_score(char)
      end
    end)
  end

  def part2(args) do
    args
    |> get_char_list()
    |> Enum.reduce([], fn line, acc ->
      case find_errors(line) do
        {:corrupted, _} -> acc
        {:incomplete, chars} -> [completion_score(chars) | acc]
      end
    end)
    |> Enum.sort()
    |> median()
  end

  defp find_errors([char | chars], stack) do
    case {classify(char), stack} do
      {{:open, closing}, _} -> find_errors(chars, [closing | stack])
      {:close, [^char | stack]} -> find_errors(chars, stack)
      {:close, _stack} -> {:corrupted, char}
    end
  end

  defp find_errors([], [_ | _] = stack), do: {:incomplete, stack}
  defp find_errors([], []), do: :ok
  defp find_errors(line), do: find_errors(line, [])

  defp classify(char_code)
  defp classify(?\(), do: {:open, ?\)}
  defp classify(?\[), do: {:open, ?\]}
  defp classify(?\{), do: {:open, ?\}}
  defp classify(?\<), do: {:open, ?\>}
  defp classify(?\)), do: :close
  defp classify(?\]), do: :close
  defp classify(?\}), do: :close
  defp classify(?\>), do: :close

  defp corrupted_score(char_code)
  defp corrupted_score(?\)), do: 3
  defp corrupted_score(?\]), do: 57
  defp corrupted_score(?\}), do: 1197
  defp corrupted_score(?\>), do: 25137

  defp char_score(char_code)
  defp char_score(?\)), do: 1
  defp char_score(?\]), do: 2
  defp char_score(?\}), do: 3
  defp char_score(?\>), do: 4

  defp completion_score(chars), do: Enum.reduce(chars, 0, &(&2 * 5 + char_score(&1)))

  defp median(list), do: Enum.at(list, div(length(list), 2))

  defp get_char_list(input) do
    input
    |> Utils.parse()
    |> Enum.map(&String.to_charlist/1)
  end
end
