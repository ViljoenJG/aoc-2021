defmodule AdventOfCode.Day18 do
  def part1(input) do
    parse(input)
    |> Enum.reduce(fn n, sum ->
      reduce([sum, n])
    end)
    |> magnitude
  end

  def part2(input) do
    numbers = parse(input)

    Enum.reduce(numbers, 0, fn n1, highest ->
      Enum.reduce(numbers -- [n1], highest, fn n2, highest ->
        max(highest, reduce([n1, n2]) |> magnitude)
      end)
    end)
  end

  def reduce(n) do
    case explode(n) do
      nil ->
        case split(n) do
          {true, n} ->
            reduce(n)

          {false, _} ->
            n
        end

      n ->
        reduce(n)
    end
  end

  def explode(n) do
    case do_explode(n, 0) do
      {_, nil, nil} ->
        nil

      {exploded, _, _} ->
        exploded
    end
  end

  defp split([a, b]) do
    case split(a) do
      {false, a} ->
        case split(b) do
          {false, b} ->
            {false, [a, b]}

          {true, b} ->
            {true, [a, b]}
        end

      {true, a} ->
        {true, [a, b]}
    end
  end

  defp split(n) when is_integer(n) and n > 9, do: {true, split_number(n)}
  defp split(other), do: {false, other}

  def split_number(n) do
    q = n / 2
    [floor(q), ceil(q)]
  end

  def magnitude(n) do
    case n do
      [a, b] ->
        magnitude(a) * 3 + 2 * magnitude(b)

      _ when is_integer(n) ->
        n
    end
  end

  defp do_explode([a, b], level) do
    if level === 4 do
      {0, [a], [b]}
    else
      {a, left, right} = do_explode(a, level + 1)
      {b, right} = propagate_right(right, b)

      case {left, right} do
        {nil, nil} ->
          {b, left, right} = do_explode(b, level + 1)
          {a, left} = propagate_left(left, a)
          {[a, b], left, right}

        {_, _} ->
          {[a, b], left, right}
      end
    end
  end

  defp do_explode(n, _) when is_integer(n), do: {n, nil, nil}

  defp propagate_left(nil, a), do: {a, nil}
  defp propagate_left([], a), do: {a, []}

  defp propagate_left([left], a) when is_integer(a) do
    {left + a, []}
  end

  defp propagate_left([left], [a, b]) do
    {b, []} = propagate_left([left], b)
    {[a, b], []}
  end

  defp propagate_right(nil, a), do: {a, nil}
  defp propagate_right([], a), do: {a, []}

  defp propagate_right([right], a) when is_integer(a) do
    {right + a, []}
  end

  defp propagate_right([right], [a, b]) do
    {a, []} = propagate_right([right], a)
    {[a, b], []}
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {:ok, term} = Code.string_to_quoted(line)
      term
    end)
  end
end
