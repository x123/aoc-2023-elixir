defmodule Day3.Matrix do
  defstruct contents: []
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
    String.split(input, "\n", trim: true)
  end

  defp debug_print(input) do
    IO.puts("#{inspect(input)}")
    input
  end

  defp load_matrix(lines) do
    # {rows, cols} = get_input_dimensions(lines)

    # m = MatrixReloaded.Matrix.new({rows, cols})
    m = %Day3.Matrix{
      contents:
        Enum.map(lines, fn line ->
          String.graphemes(line)
        end)
    }
  end

  defp get_input_dimensions(lines) do
    rows = length(lines)
    cols = hd(lines) |> String.graphemes() |> length()
    {rows, cols}
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [file: :string])

    {opts, List.to_string(word)}
  end
end
