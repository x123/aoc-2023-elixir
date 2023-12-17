defmodule CalibrationSum do
  @bag_contents %{
    :red => 12,
    :green => 13,
    :blue => 14
  }

  def run(file_path) do
    lines =
      file_path
      |> File.stream!()
      |> Enum.map(&String.trim/1)

    lines
    |> Enum.map(fn line ->
      Regex.named_captures(~r/Game (?<game_id>\d+): (?<results>.*)$/, line)
    end)
    |> Enum.map(fn game ->
      %{
        :game_id => String.to_integer(Map.get(game, "game_id")),
        :results =>
          Enum.map(
            String.split(Map.get(game, "results"), ";", trim: true),
            &String.trim(&1)
          )
          |> Enum.map(fn input ->
            red = Regex.run(~r/(?<red>\d+) red/, input, capture: :all_names)
            green = Regex.run(~r/(?<green>\d+) green/, input, capture: :all_names)
            blue = Regex.run(~r/(?<blue>\d+) blue/, input, capture: :all_names)

            %{
              :red => convert_to_digit(red),
              :green => convert_to_digit(green),
              :blue => convert_to_digit(blue)
            }
          end)
      }
    end)
  end

  def valid_game?(game) do
    Map.get(game, :results)
    |> Enum.all?(
      &(&1.red <= @bag_contents.red &&
          &1.green <= @bag_contents.green &&
          &1.blue <= @bag_contents.blue)
    )
  end

  def max_red(game) do
    Map.get(game, :results)
    |> Enum.map(&Map.get(&1, :red))
    |> Enum.max()
  end

  def max_green(game) do
    Map.get(game, :results)
    |> Enum.map(&Map.get(&1, :green))
    |> Enum.max()
  end

  def max_blue(game) do
    Map.get(game, :results)
    |> Enum.map(&Map.get(&1, :blue))
    |> Enum.max()
  end

  defp convert_to_digit(input) do
    if input == nil do
      0
    else
      String.to_integer(hd(input))
    end
  end
end

results = CalibrationSum.run("./input/day2-1.real")

# Day2-1
day2_1 =
  Enum.filter(results, &CalibrationSum.valid_game?(&1))
  |> Enum.map(& &1.game_id)
  |> Enum.sum()

IO.puts("Day 2-1 Answer: #{day2_1}")

# Day2-2
day2_2 =
  results
  |> Enum.map(fn input ->
    # IO.puts("#{inspect input}")
    %{
      :game_id => Map.get(input, :game_id),
      :results => Map.get(input, :results),
      :power =>
        CalibrationSum.max_red(input) * CalibrationSum.max_green(input) *
          CalibrationSum.max_blue(input),
      :needed => %{
        :red => CalibrationSum.max_red(input),
        :green => CalibrationSum.max_green(input),
        :blue => CalibrationSum.max_blue(input)
      }
    }
  end)
  |> Enum.map(fn input ->
    # IO.puts("#{inspect input}")
    Map.get(input, :power)
  end)
  |> Enum.sum()

IO.puts("Day 2-2 Answer: #{day2_2}")
