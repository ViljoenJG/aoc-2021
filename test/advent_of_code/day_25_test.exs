defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  import AdventOfCode.Day25

  @input """
  v...>>.vv>
  .vv>>.vv..
  >>.>v>...v
  >>v>>.>.v.
  v>v.vv.v..
  >.>>..v...
  .vv..>.>v.
  v.v..>>v.v
  ....v..v.>
  """

  test "part1" do
    result = part1(@input)
    assert result == 58
  end

  @tag :skip
  test "part2" do
    result = part2(@input)
    assert result
  end
end
