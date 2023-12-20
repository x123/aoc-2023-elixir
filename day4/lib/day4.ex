defmodule Day4.Card do
  defstruct card_id: nil,
            winning_numbers: [],
            player_numbers: [],
            score: nil

  def parse_game(line) do
    # IO.puts("> line:#{inspect(line)}")
    re = ~r/^Card\s+(?<card_id>\d+):\s+(?<winning_numbers>\d.*) \| (?<player_numbers>.*)$/
    matches = Regex.named_captures(re, line)
    # IO.puts("> matches:#{inspect(matches)}")

    card_id =
      Map.get(matches, "card_id")
      |> String.to_integer()

    winning_numbers =
      Map.get(matches, "winning_numbers")
      |> parse_numbers()

    player_numbers =
      Map.get(matches, "player_numbers")
      |> parse_numbers()

    # IO.puts(
    #  "card_id:#{inspect(card_id)} winning_numbers:#{inspect(winning_numbers)} player_numbers:#{inspect(player_numbers)}"
    # )

    card = %Day4.Card{
      card_id: card_id,
      winning_numbers: winning_numbers,
      player_numbers: player_numbers
    }

    card = %{
      card
      | score: score_card(card)
    }
  end

  defp score_card(card) do
    tmp_list = card.player_numbers -- card.winning_numbers
    matching = card.player_numbers -- tmp_list

    cond do
      length(matching) >= 1 ->
        score = 2 ** (length(matching) - 1)
        score

      true ->
        score = 0
        score
    end
  end

  defp parse_numbers(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> List.flatten()
  end
end

defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  @doc """
  Main executable function.
  """
  def main(args \\ []) do
    input =
      args
      |> parse_args()
      |> load_file()

    cards =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&Day4.Card.parse_game(&1))

    sum =
      cards
      |> Enum.map(& &1.score)
      |> Enum.sum()

    IO.puts("Day4-1 Answer:#{inspect(sum)}")
  end

  defp load_file({opts, word}) do
    IO.puts("opts:#{inspect(opts)}")
    IO.puts("word:#{inspect(word)}")
    if opts[:file], do: File.read!(opts[:file]), else: nil
  end

  defp debug_print(input) do
    IO.puts("#{inspect(input)}")
    input
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [file: :string])

    {opts, List.to_string(word)}
  end
end
