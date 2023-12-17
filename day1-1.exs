defmodule CalibrationSum do
  @word_map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
    "zero" => "0"
  }

  def run(file_path) do
    file_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc ->
      word_regex = "(" <> Enum.join(Map.keys(@word_map), "|") <> ")"
      word_numbers = Regex.scan(~r/#{word_regex}/, line)
      words_reduced = Enum.map(word_numbers, &hd(&1))
      IO.puts("line:#{inspect(line)}")
      IO.puts("word_numbers:#{inspect(word_numbers)}")
      IO.puts("words_reduced:#{inspect(words_reduced)}")

      Enum.each(words_reduced, fn item ->
        String.replace(line, item, Map.get(@word_map, item), global: false)
      end)

      IO.puts("adjusted line:#{inspect(line)}")
      # Extract all digits
      digits = Regex.scan(~r/\d/, line) |> List.flatten()

      # Check if we have at least one digit
      if Enum.count(digits) > 0 do
        # Get first and last digit
        first_digit = hd(digits)
        last_digit = List.last(digits)

        # Convert to two-digit number and sum
        two_digit_number = String.to_integer(first_digit <> last_digit)
        acc + two_digit_number
      else
        acc
      end
    end)
  end
end

sum = CalibrationSum.run("./input/day1-2.example")
IO.puts("The sum of all calibration values is: #{sum}")
