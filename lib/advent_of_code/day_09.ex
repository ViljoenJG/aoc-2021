defmodule AdventOfCode.Day09 do
  alias AdventOfCode.Utils

  def part1(args) do
    coord_lookup = get_coord_lookup(args)

    Enum.reduce(coord_lookup, 0, fn {coord, height}, acc ->
      neighbour_height =
        neighbour_coords(coord_lookup, coord)
        |> Enum.map(&Map.fetch!(coord_lookup, &1))
        |> Enum.min()

      case height < neighbour_height do
        true -> acc + height + 1
        false -> acc
      end
    end)
  end

  def part2(args) do
    # Discard highest possible points.
    lookup =
      args
      |> get_coord_lookup()
      |> Enum.reject(fn {_k, v} -> v == 9 end)
      |> Map.new()

    union_map =
      lookup
      |> Enum.map(fn {k, _v} -> {k, k} end)
      |> Map.new()

    Enum.reduce(union_map, union_map, fn {this, _}, acc ->
      neighbour_coords(lookup, this)
      |> Enum.reduce(acc, fn neighbor, acc ->
        union(acc, this, neighbor)
      end)
    end)
    |> Enum.group_by(fn {_, value} -> value end)
    |> Enum.map(fn {_, members} -> length(members) end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp union(union_map, point_a, point_b) do
    case union_map do
      %{^point_a => x, ^point_b => x} ->
        union_map

      %{^point_a => x, ^point_b => y} ->
        Enum.reduce(
          union_map,
          union_map,
          fn
            {key, ^x}, acc -> Map.put(acc, key, y)
            {_, _}, acc -> acc
          end
        )
    end
  end

  defp neighbour_coords(lookup, {x, y} = _coord) do
    [{x, y + 1}, {x + 1, y}, {x, y - 1}, {x - 1, y}]
    |> Enum.filter(&Map.has_key?(lookup, &1))
  end

  defp get_coord_lookup(input) do
    input
    |> Utils.parse()
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.flat_map(fn {list, x} ->
      list
      |> Enum.with_index()
      |> Enum.map(fn {height, y} -> {{x, y}, height} end)
    end)
    |> Map.new()
  end
end
