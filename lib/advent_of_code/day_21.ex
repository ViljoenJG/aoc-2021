defmodule AdventOfCode.Day21 do
  alias __MODULE__.{Part1, Part2}

  def part1(args) do
    args
    |> parse()
    |> Part1.play()
  end

  def part2(args) do
    args
    |> parse()
    |> Part2.play()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/Player \d starting position: /, ""))
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AdventOfCode.Day21.Part1 do
  def play(positions) do
    {p1, p2, dice} = setup(positions)
    play(p1, p2, dice)
  end

  def play(player1, player2, dice) do
    case player_turn(player1, dice) do
      {:win, _p, {_d, r}} ->
        Map.get(player2, :score, 0) * r

      {:continue, p1, d1} ->
        case player_turn(player2, d1) do
          {:win, _p2, {_d2, r2}} -> Map.get(p1, :score, 0) * r2
          {:continue, p2, d2} -> play(p1, p2, d2)
        end
    end
  end

  defp player_turn(%{score: s, pos: p} = pl, dice, turns \\ 3) do
    {acc, dice} = roll_dice(dice, turns, 0)

    new = p + acc

    pos =
      cond do
        new > 10 ->
          remainder = rem(new, 10)
          if remainder == 0, do: 10, else: remainder

        true ->
          p + acc
      end

    score = s + pos
    player = %{pl | score: score, pos: pos}

    cond do
      score >= 1000 -> {:win, player, dice}
      true -> {:continue, player, dice}
    end
  end

  defp roll_dice(dice, 0, acc), do: {acc, dice}

  defp roll_dice({cur, rolls}, turns, acc) do
    new = if cur + 1 == 101, do: 1, else: cur + 1
    roll_dice({new, rolls + 1}, turns - 1, acc + new)
  end

  defp setup([p1_pos, p2_pos]) do
    player1 = %{player: 1, pos: p1_pos, score: 0}
    player2 = %{player: 2, pos: p2_pos, score: 0}
    dice = {_cur = 0, _rolls = 0}
    {player1, player2, dice}
  end
end

defmodule AdventOfCode.Day21.Part2 do
  @inc (for u1 <- 1..3, u2 <- 1..3, u3 <- 1..3 do
          Enum.sum([u1, u2, u3])
        end)
       |> Enum.frequencies()

  def play([p1start, p2start]) do
    solve2(p1start, p2start)
  end

  def play(pos, inc) do
    sum = pos + rem(inc, 10)
    if sum > 10, do: sum - 10, else: sum
  end

  def solve2(p1start, p2start) do
    Stream.iterate({[{{p1start, 0, p2start, 0}, 1}], 1}, &split/1)
    |> Stream.map(&elem(&1, 0))
    |> Enum.take_while(fn
      [] -> false
      _ -> true
    end)
    |> Enum.reduce({0, 0}, fn state, {s1, s2} ->
      {s1 +
         (state
          |> Enum.filter(fn {{_, s, _, _}, _} -> s >= 21 end)
          |> Enum.map(fn {_, c} -> c end)
          |> Enum.sum()),
       s2 +
         (state
          |> Enum.filter(fn {{_, _, _, s}, _} -> s >= 21 end)
          |> Enum.map(fn {_, c} -> c end)
          |> Enum.sum())}
    end)
    |> then(fn {left, right} -> max(left, right) end)
  end

  def split({state, turn}) do
    play_turn(state, turn)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)
    |> then(&{&1, turn + 1})
  end

  defp play_turn(state, turn) do
    if rem(turn, 2) == 1 do
      for {{p1, s1, p2, s2}, c1} <- state, s2 < 21, {inc, c2} <- @inc do
        p1 = play(p1, inc)
        {{p1, s1 + p1, p2, s2}, c1 * c2}
      end
    else
      for {{p1, s1, p2, s2}, c1} <- state, s1 < 21, {inc, c2} <- @inc do
        p2 = play(p2, inc)
        {{p1, s1, p2, s2 + p2}, c1 * c2}
      end
    end
  end
end
