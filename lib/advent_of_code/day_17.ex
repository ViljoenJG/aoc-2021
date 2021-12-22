defmodule AdventOfCode.Day17 do
  def part1(args) do
    [range_x, range_y] = parse(args)

    _min_x.._max_x = range_x
    min_y.._max_y = range_y

    y_trajectory = fn vy ->
      Stream.iterate(0, &(&1 + 1))
      |> Stream.transform({0, vy}, fn _, {y, vy} ->
        {[y], {y + vy, vy - 1}}
      end)
      |> Stream.take_while(fn y -> y >= min_y end)
    end

    vy_hits_box? = fn vy ->
      Enum.at(y_trajectory.(vy), -1) in range_y
    end

    highest_vy =
      0..abs(min_y + 1)
      |> Enum.filter(vy_hits_box?)
      |> Enum.at(-1)

    Enum.max(y_trajectory.(highest_vy))
  end

  def part2(args) do
    [range_x, range_y] = parse(args)

    _min_x..max_x = range_x
    min_y.._max_y = range_y

    simulate = fn vx, vy ->
      Stream.iterate(0, &(&1 + 1))
      |> Stream.transform({0, 0, vx, vy}, fn _, {x, y, vx, vy} ->
        {[{x, y}], {x + vx, y + vy, max(vx - 1, 0), vy - 1}}
      end)
      |> Stream.take_while(fn {x, y} -> x <= max_x and y >= min_y end)
    end

    vxy_hits_box? = fn vx, vy ->
      {x, y} = Enum.at(simulate.(vx, vy), -1)
      x in range_x and y in range_y
    end

    possible_vxy =
      for vx <- 0..max_x,
          vy <- min_y..abs(min_y + 1),
          vxy_hits_box?.(vx, vy),
          do: {vx, vy}

    Enum.count(possible_vxy)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> hd
    |> String.split(", ", trim: true)
    |> Enum.map(&String.replace(&1, ~r/[^\d^\.-]/, ""))
    |> Enum.map(fn range_str ->
      [x, y] = String.split(range_str, "..") |> Enum.map(&String.to_integer/1)
      Range.new(x, y)
    end)
  end
end
