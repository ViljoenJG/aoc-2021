defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @input """
  target area: x=20..30, y=-10..-5
  """

  test "part1" do
    assert part1(@input) == 45
  end

  test "part2" do
    assert part2(@input) == 112
  end
end
