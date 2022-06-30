defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  import AdventOfCode.Day24

  @input """
  inp w
  add z w
  mod z 2
  div w 2
  add y w
  mod y 2
  div w 2
  add x w
  mod x 2
  div w 2
  mod w 2
  """

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 13_579_246_899_999
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
