defmodule AdventOfCode.Day11 do
  def part1(args) do
    grid = get_grid(args)

    1..100
    |> Enum.map_reduce(grid, fn _, grid ->
      {grid, flashes} = step(grid)
      {flashes, grid}
    end)
    |> elem(0)
    |> Enum.sum()
  end

  def part2(args) do
    grid = get_grid(args)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(grid, fn i, grid ->
      case step(grid) do
        {grid, flashes} when map_size(grid) == flashes -> {:halt, i}
        {grid, _flashes} -> {:cont, grid}
      end
    end)
  end

  def step(grid) do
    flash(Map.keys(grid), grid, MapSet.new())
  end

  defp flash([{row, col} = key | keys], grid, flashed) do
    value = grid[key]

    cond do
      is_nil(value) or key in flashed ->
        flash(keys, grid, flashed)

      grid[key] >= 9 ->
        keys = [
          {row - 1, col - 1},
          {row - 1, col},
          {row - 1, col + 1},
          {row, col - 1},
          {row, col + 1},
          {row + 1, col - 1},
          {row + 1, col},
          {row + 1, col + 1}
          | keys
        ]

        flash(keys, Map.put(grid, key, 0), MapSet.put(flashed, key))

      true ->
        flash(keys, Map.put(grid, key, value + 1), flashed)
    end
  end

  defp flash([], grid, flashed) do
    {grid, MapSet.size(flashed)}
  end

  defp get_grid(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {energy, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{},
        do: {{row, col}, energy - ?0}
  end
end
