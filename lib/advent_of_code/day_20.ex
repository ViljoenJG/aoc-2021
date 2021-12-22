defmodule AdventOfCode.Day20 do
  use Bitwise

  def part1(args) do
    args
    |> String.split("\n")
    |> parse()
    |> solve(2)
  end

  def part2(args) do
    args
    |> String.split("\n")
    |> parse()
    |> solve(50)
  end

  defp parse([algorithm | image]) do
    {
      parse_algorithm(algorithm),
      parse_image(image)
    }
  end

  defp parse_algorithm(algorithm) do
    algorithm
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn
      {"#", i} -> {i, 1}
      {".", i} -> {i, 0}
    end)
    |> Enum.into(%{})
  end

  defp parse_image(rows), do: parse_image(rows, %{}, 0)

  defp parse_image([] = _image_rows, acc, _row_num), do: acc

  defp parse_image([row | rows] = _image_rows, acc, y),
    do:
      parse_image(rows, row |> String.split("", trim: true) |> parse_image_row(acc, y, 0), y + 1)

  defp parse_image_row(chars, acc, y, x)
  defp parse_image_row([], acc, _, _), do: acc

  defp parse_image_row(["#" | chars], acc, y, x),
    do: parse_image_row(chars, acc |> Map.put({x, y}, 1), y, x + 1)

  defp parse_image_row(["." | chars], acc, y, x),
    do: parse_image_row(chars, acc |> Map.put({x, y}, 0), y, x + 1)

  defp solve({algorithm, image}, steps) do
    {first_idx, last_idx} = Enum.min_max(Map.keys(algorithm))

    enhance(
      image,
      algorithm,
      steps,
      _default_pointer = algorithm[first_idx],
      _defaults = %{
        0 => algorithm[first_idx],
        1 => algorithm[last_idx]
      }
    )
    |> Map.values()
    |> Enum.filter(fn v -> v == 1 end)
    |> Enum.count()
  end

  defp enhance(image, algorithm, steps, _default_pointer, defaults)
  defp enhance(img, _, 0, _, _), do: img

  defp enhance(img_map, algorithm, steps, default_pointer, defaults) do
    {min_x, max_x, min_y, max_y} = img_map |> Map.keys() |> find_min_max(0, 0, 0, 0)

    (min_x - 3)..(max_x + 3)
    |> Enum.to_list()
    |> transform_image(
      (min_y - 3)..(max_y + 3) |> Enum.to_list(),
      %{},
      img_map,
      algorithm,
      defaults[default_pointer]
    )
    |> enhance(algorithm, steps - 1, defaults[default_pointer], defaults)
  end

  defp transform_image([], _, acc, _, _, _), do: acc

  defp transform_image([x | rows], y, acc, src, algorithm, default),
    do:
      transform_image(
        rows,
        y,
        transform_rows(acc, x, y, src, algorithm, default),
        src,
        algorithm,
        default
      )

  defp transform_rows(acc, _, [], _, _, _), do: acc

  defp transform_rows(acc, x, [y | rows], src, algorithm, default),
    do:
      acc
      |> maybe_put({x, y}, get_pixel(x, y, src, algorithm, default))
      |> transform_rows(x, rows, src, algorithm, default)

  defp maybe_put(acc, c, 0), do: acc |> Map.put(c, 0)
  defp maybe_put(acc, c, 1), do: acc |> Map.put(c, 1)

  defp get_pixel(x, y, src, algorithm, default) do
    crd =
      [
        src |> Map.get({x - 1, y - 1}, default),
        src |> Map.get({x, y - 1}, default),
        src |> Map.get({x + 1, y - 1}, default),
        src |> Map.get({x - 1, y}, default),
        src |> Map.get({x, y}, default),
        src |> Map.get({x + 1, y}, default),
        src |> Map.get({x - 1, y + 1}, default),
        src |> Map.get({x, y + 1}, default),
        src |> Map.get({x + 1, y + 1}, default)
      ]
      |> to_number(0)

    algorithm |> Map.get(crd)
  end

  defp to_number([], r), do: r
  defp to_number([1 | rows], r), do: to_number(rows, (r <<< 1) + 1)
  defp to_number([0 | rows], r), do: to_number(rows, r <<< 1)

  defp find_min_max([], min_x, max_x, min_y, max_y), do: {min_x, max_x, min_y, max_y}

  defp find_min_max([{x, y} | rest], min_x, max_x, min_y, max_y) when x < min_x and y < min_y,
    do: find_min_max(rest, x, max_x, y, max_y)

  defp find_min_max([{x, y} | rest], min_x, max_x, min_y, max_y) when x > max_x and y > max_y,
    do: find_min_max(rest, min_x, x, min_y, y)

  defp find_min_max([{x, y} | rest], min_x, max_x, min_y, max_y) when x > max_x and y < min_y,
    do: find_min_max(rest, min_x, x, y, max_y)

  defp find_min_max([{x, y} | rest], min_x, max_x, min_y, max_y) when x < min_x and y > max_y,
    do: find_min_max(rest, x, max_x, min_y, y)

  defp find_min_max([{x, _} | rest], min_x, max_x, min_y, max_y) when x > max_x,
    do: find_min_max(rest, min_x, x, min_y, max_y)

  defp find_min_max([{x, _} | rest], min_x, max_x, min_y, max_y) when x < min_x,
    do: find_min_max(rest, x, max_x, min_y, max_y)

  defp find_min_max([{_, y} | rest], min_x, max_x, min_y, max_y) when y < min_y,
    do: find_min_max(rest, min_x, max_x, y, max_y)

  defp find_min_max([{_, y} | rest], min_x, max_x, min_y, max_y) when y > max_y,
    do: find_min_max(rest, min_x, max_x, min_y, y)

  defp find_min_max([_ | rest], min_x, max_x, min_y, max_y),
    do: find_min_max(rest, min_x, max_x, min_y, max_y)
end
