defmodule Day3.Matrix do
  @part_symbols ["*", "#", "+", "$"]
  defstruct contents: [],
            dimensions: {},
            part_locations: []

  def pretty_print(matrix) do
    Enum.each(matrix.contents, fn contents ->
      contents
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  def find_part_locations(matrix) do
    matrix.contents
    |> Enum.with_index()
    |> Enum.map(fn {content, row_index} ->
      # IO.puts("row_index:#{row_index} content:#{inspect content}")
      content
      |> Enum.with_index()
      |> Enum.map(fn {char, col_index} ->
        if char in @part_symbols do
          # IO.puts("part_symbol #{inspect(char)} found at {#{row_index},#{col_index}}")
          {row_index, col_index}
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(& &1)
  end
end

defimpl Inspect, for: Day3.Matrix do
  def inspect(matrix, opts) do
    Enum.join(
      [
        "dimensions: #{inspect(matrix.dimensions)}",
        "part_locations: #{inspect(matrix.part_locations)}",
        Enum.join(matrix.contents, "\n")
      ],
      "\n"
    )
  end
end

defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  @doc """
  Main executable function.
  """
  def main(args \\ []) do
    matrix =
      args
      |> parse_args()
      |> load_file()
      |> process_input()
      |> load_matrix()

    # Day3.Matrix.pretty_print(matrix)

    matrix =
      %{
        matrix
        | part_locations: Day3.Matrix.find_part_locations(matrix)
      }

    debug_print(matrix)
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
