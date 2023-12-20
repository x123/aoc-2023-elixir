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

    debug_print(input)
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
