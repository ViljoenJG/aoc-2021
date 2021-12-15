defmodule AdventOfCode.Day12 do
  def part1(args) do
    args
    |> get_edges()
    |> find_paths()
  end

  def part2(args) do
    args
    |> get_edges()
    |> find_paths(:part2)
  end

  defp find_paths(edges) do
    find_paths(edges["start"], edges, MapSet.new(), ["start"], 0)
  end

  def find_paths(edges, :part2) do
    find_paths(edges["start"], edges, MapSet.new(), false, ["start"], 0)
  end

  defp find_paths(["end" | caves], edges, seen, path, count) do
    find_paths(caves, edges, seen, path, count + 1)
  end

  defp find_paths([cave | caves], edges, seen, path, count) do
    count =
      cond do
        cave == "start" or cave in seen ->
          count

        small_cave?(cave) ->
          find_paths(edges[cave], edges, MapSet.put(seen, cave), [cave | path], count)

        true ->
          find_paths(edges[cave], edges, seen, [cave | path], count)
      end

    find_paths(caves, edges, seen, path, count)
  end

  defp find_paths([], _edges, _seen, _path, count) do
    count
  end

  defp find_paths(["end" | caves], edges, seen, once?, path, count) do
    find_paths(caves, edges, seen, once?, path, count + 1)
  end

  defp find_paths([cave | caves], edges, seen, once?, path, count) do
    count =
      cond do
        cave == "start" or (cave in seen and once?) ->
          count

        cave in seen ->
          find_paths(edges[cave], edges, MapSet.put(seen, cave), true, [cave | path], count)

        small_cave?(cave) ->
          find_paths(edges[cave], edges, MapSet.put(seen, cave), once?, [cave | path], count)

        true ->
          find_paths(edges[cave], edges, seen, once?, [cave | path], count)
      end

    find_paths(caves, edges, seen, once?, path, count)
  end

  defp find_paths([], _edges, _seen, _path, _once?, count) do
    count
  end

  defp small_cave?(cave), do: String.downcase(cave, :ascii) == cave

  defp get_edges(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [left, right] = String.split(line, "-")
      acc = Map.update(acc, left, [right], &[right | &1])

      if left == "start" or right == "end" do
        acc
      else
        Map.update(acc, right, [left], &[left | &1])
      end
    end)
  end
end
