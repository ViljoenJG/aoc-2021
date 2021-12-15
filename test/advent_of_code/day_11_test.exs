defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @input """
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  test "part1" do
    assert part1(@input) == 1656
  end

  test "part2" do
    assert part2(@input) == 195
  end
end
