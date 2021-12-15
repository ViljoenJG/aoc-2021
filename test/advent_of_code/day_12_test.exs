defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input1 """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  @input2 """
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
  """

  @input3 """
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  """

  test "part1" do
    assert part1(@input1) == 10
    assert part1(@input2) == 19
    assert part1(@input3) == 226
  end

  test "part2" do
    assert part2(@input1) == 36
    assert part2(@input2) == 103
    assert part2(@input3) == 3509
  end
end
