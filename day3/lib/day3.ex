defmodule Day3.Matrix do
  defstruct [
    contents: [],
    dimensions: {},
  ]
end

defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  @doc """
  Main executable function.
  """
  def main(args \\ []) do
    args
    |> parse_args()
    |> load_file()
    |> process_input()
    |> debug_print()
    |> load_matrix()
    |> debug_print()
  end

  defp load_file({opts, word}) do
    IO.puts("opts:#{inspect(opts)}")
    IO.puts("word:#{inspect(word)}")
    if opts[:file], do: File.read!(opts[:file]), else: nil
  end

  defp process_input(input) do
    if input do
      String.split(input, "\n", trim: true)
    else
      raise("no input to process, try using --file someinput.txt")
    end
  end

  defp debug_print(input) do
    IO.puts("#{inspect(input)}")
    input
  end

  defp load_matrix(lines) do
    %Day3.Matrix{
      contents:
        Enum.map(lines, fn line ->
          String.graphemes(line)
        end),
      dimensions: {
        length(lines),
        hd(lines) |> String.graphemes() |> length()
      }
    }
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [file: :string])

    {opts, List.to_string(word)}
  end
end
