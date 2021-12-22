defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.Day21

  @input """
  Player 1 starting position: 4
  Player 2 starting position: 8
  """

  test "part1" do
    assert part1(@input) == 739_785
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
