defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  @input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  test "part1" do
    assert part1(@input) == 40
  end

  test "part2" do
    assert part2(@input) == 315
  end
end
