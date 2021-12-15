defmodule AdventOfCode.Day13 do
  def part1(input) do
    {dots, folds} = parse(input)
    {axis, value} = hd(folds)

    dots
    |> MapSet.new()
    |> fold(axis, value)
    |> MapSet.size()
  end

  def part2(input) do
    {dots, folds} = parse(input)

    folds
    |> Enum.reduce(MapSet.new(dots), fn {axis, value}, dots ->
      fold(dots, axis, value)
    end)
    |> print_grid()
  end

  defp fold(dots, axis, value) do
    moved = moved_dots(dots, axis, value)
    mirrored = mirrored_dots(moved, axis, value)

    dots
    |> MapSet.difference(moved)
    |> MapSet.union(mirrored)
  end

  defp moved_dots(dots, axis, value) do
    moved =
      case axis do
        :x ->
          fn {x, _} -> x > value end

        :y ->
          fn {_, y} -> y > value end
      end

    dots
    |> Enum.filter(moved)
    |> MapSet.new()
  end

  defp mirrored_dots(dots, axis, value) do
    double_value = 2 * value

    mirror =
      case axis do
        :x ->
          fn {x, y} -> {double_value - x, y} end

        :y ->
          fn {x, y} -> {x, double_value - y} end
      end

    dots
    |> Enum.map(mirror)
    |> MapSet.new()
  end

  defp print_grid(grid) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(grid, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(grid, &elem(&1, 1))

    Enum.each(min_y..max_y, fn y ->
      Enum.map(min_x..max_x, fn x ->
        case MapSet.member?(grid, {x, y}) do
          true -> ?\#
          false -> ?\s
        end
      end)
      |> IO.puts()
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case String.split(line, ",") do
        [_, _] = numbers ->
          Enum.map(numbers, &String.to_integer/1)
          |> List.to_tuple()

        [<<"fold along ", axis, "=", number::binary>>] ->
          {List.to_atom([axis]), String.to_integer(number)}
      end
    end)
    |> Enum.split_while(fn {n, _} -> is_integer(n) end)
  end
end
