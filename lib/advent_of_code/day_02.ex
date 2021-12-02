defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Utils

  def part1(args) do
    args
    |> Utils.parse()
    |> calculate_position()
  end

  defp calculate_position(lines), do: calculate_position(lines, 0, 0)

  defp calculate_position(["forward " <> dist | lines], horizontal, depth) do
    calculate_position(lines, horizontal + String.to_integer(dist), depth)
  end

  defp calculate_position(["down " <> dist | lines], horizontal, depth) do
    calculate_position(lines, horizontal, depth + String.to_integer(dist))
  end

  defp calculate_position(["up " <> dist | lines], horizontal, depth) do
    calculate_position(lines, horizontal, depth - String.to_integer(dist))
  end

  defp calculate_position([], horizontal, depth), do: horizontal * depth

  def part2(args) do
    args
    |> Utils.parse()
    |> calculate_with_aim()
  end

  defp calculate_with_aim(lines), do: calculate_with_aim(lines, 0, 0, 0)

  defp calculate_with_aim(["down " <> dist | lines], horizontal, depth, aim) do
    calculate_with_aim(lines, horizontal, depth, aim + String.to_integer(dist))
  end

  defp calculate_with_aim(["up " <> dist | lines], horizontal, depth, aim) do
    calculate_with_aim(lines, horizontal, depth, aim - String.to_integer(dist))
  end

  defp calculate_with_aim(["forward " <> dist | lines], horizontal, depth, aim) do
    dist = String.to_integer(dist)
    calculate_with_aim(lines, horizontal + dist, depth + dist * aim, aim)
  end

  defp calculate_with_aim([], horizontal, depth, _aim) do
    horizontal * depth
  end
end
