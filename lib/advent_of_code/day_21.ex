defmodule AdventOfCode.Day21 do
  def part1(args) do
    args
    |> parse()
    |> play()
  end

  def part2(args) do
  end

  defp setup([p1_pos, p2_pos]) do
    player1 = %{player: 1, pos: p1_pos, score: 0}
    player2 = %{player: 2, pos: p2_pos, score: 0}
    dice = {_cur = 0, _rolls = 0}
    {player1, player2, dice}
  end

  defp play(positions) do
    {p1, p2, dice} = setup(positions)
    play(p1, p2, dice)
  end

  defp play(player1, player2, dice) do
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

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r/Player \d starting position: /, ""))
    |> Enum.map(&String.to_integer/1)
  end
end
