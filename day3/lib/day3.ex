defmodule Day3.Matrix do
  @gear_symbols ["*"]
  @part_symbols ["*", "+", "#", "%", "&", "-", "/", "=", "@", "$"]
  defstruct contents: [],
            dimensions: {},
            part_locations: [],
            numbers: [],
            possible_gear_locations: [],
            gear_locations: []

  def pretty_print(matrix) do
    Enum.each(matrix.contents, fn contents ->
      contents
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  def find_gear_ratio_sum(matrix) do
    matrix.possible_gear_locations
    |> Enum.map(fn possible_gear_location ->
      adjacent_numbers = Enum.filter(matrix.numbers,
          &(
            (
              elem(possible_gear_location, 0) == &1.pos.row
              || elem(possible_gear_location, 0) + 1 == &1.pos.row
              || elem(possible_gear_location, 0) - 1 == &1.pos.row
            )
            &&
              (elem(possible_gear_location, 1) in (&1.pos.col - 1)..(&1.pos.col + &1.length))
          )
      )
      |> List.flatten()
    end)
    |> Enum.filter(&is_list(&1))
    |> Enum.filter(&length(&1) == 2)
    |> Enum.map(fn adjacent_nums_list ->
      Enum.map(adjacent_nums_list, fn num ->
        num.number
      end)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def find_part_numbers(matrix, opts \\ [debug: false]) do
    matrix.numbers
    |> Enum.map(fn number ->
      if(opts[:debug],
        do: IO.puts("> number:#{inspect(number)}")
      )
        matrix.part_locations
        |> Enum.filter(
          &(
            (
              elem(&1, 0) == number.pos.row
              || elem(&1, 0) + 1 == number.pos.row
              || elem(&1, 0) - 1 == number.pos.row
            )
            &&
              (elem(&1, 1) in (number.pos.col - 1)..(number.pos.col + number.length))
          )
        )
        |> Enum.map(fn part_location ->
          if(opts[:debug],
            do: IO.puts(">> part_location:#{inspect(part_location)} number:#{inspect number}")
          )
          number.number
        end)
    end)
    |> List.flatten()
  end

  def find_numbers(matrix, opts \\ [debug: false]) do
    matrix.contents
    |> Enum.with_index()
    |> Enum.map(fn {content, row_index} ->
      line = Enum.join(content)
      result = Regex.scan(~r/\d+/, line, return: :index) |> List.flatten()

      if(opts[:debug],
        do: IO.puts("> result:#{inspect(result)}")
      )

      cond do
        length(result) > 0 ->
          {result, row_index, line}

        true ->
          nil
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.map(fn {positions, row_index, line} ->
      if(opts[:debug],
        do:
          IO.puts(
            ">> row_index:#{inspect(row_index)} positions:#{inspect(positions)} line:#{inspect(line)}"
          )
      )

      Enum.map(positions, fn position ->
        {col_index, length} = position
        number = String.slice(line, col_index, length) |> String.to_integer()

        if(opts[:debug],
          do:
            IO.puts(
              ">>> position:{#{inspect(row_index)},#{col_index}} length:#{inspect(length)} number:#{inspect(number)}"
            )
        )

        %{pos: %{row: row_index, col: col_index}, length: length, number: number}
      end)
      |> List.flatten()
    end)
    |> List.flatten()
  end

  def find_part_locations(matrix, opts \\ [parts: true, gears: false, debug: false]) do
    matrix.contents
    |> Enum.with_index()
    |> Enum.map(fn {content, row_index} ->
      if(opts[:debug],
        do: IO.puts("row_index:#{row_index} content:#{inspect(content)}")
      )

      content
      |> Enum.with_index()
      |> Enum.map(fn {char, col_index} ->
        cond do
          opts[:parts] == true ->
            if char in @part_symbols do
              if(opts[:debug],
                do: IO.puts("part_symbol #{inspect(char)} found at {#{row_index},#{col_index}}")
              )

              {row_index, col_index}
            end
          opts[:gears] == true ->
            if char in @gear_symbols do
              if(opts[:debug],
                do: IO.puts("gear_symbol #{inspect(char)} found at {#{row_index},#{col_index}}")
              )

              {row_index, col_index}
            end
          true ->
            raise("specify either parts: true or gears: true")
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
        "numbers: #{inspect(matrix.numbers)}",
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

    matrix =
      %{
        matrix
        | part_locations: Day3.Matrix.find_part_locations(matrix, [parts: true, debug: false]),
          possible_gear_locations: Day3.Matrix.find_part_locations(matrix, [gears: true, debug: false]),
          numbers: Day3.Matrix.find_numbers(matrix, debug: false)
      }

    part_numbers = Day3.Matrix.find_part_numbers(matrix, debug: false)
    part_number_sum = Enum.sum(part_numbers)
    IO.puts("Day 3-1 Answer:#{part_number_sum}")

    gear_ratio_sum = Day3.Matrix.find_gear_ratio_sum(matrix)
    IO.puts("Day 3-2 Answer:#{gear_ratio_sum}")
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
