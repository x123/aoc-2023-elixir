defmodule CalibrationSum do
  @digit_map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def run(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(0, fn line, acc ->
      # line = String.trim(line)
      # Extract all digit words and digits
      digit_matches =
        Regex.scan(~r/one|two|three|four|five|six|seven|eight|nine|\d/, line)
        |> List.flatten()

      IO.puts("digit_matches:#{inspect(digit_matches)}")

      if Enum.count(digit_matches) >= 1 do
        # Convert first and last match to digit
        first_digit = hd(digit_matches)
        # [first_digit | _] = digit_matches
        last_digit = List.last(digit_matches)

        first_digit_num = convert_to_digit(first_digit)
        last_digit_num = convert_to_digit(last_digit)

        two_digit_number = String.to_integer(first_digit_num <> last_digit_num)
        IO.puts("line:#{inspect(line)} 2-digit:#{inspect(two_digit_number)}")
        two_digit_number + acc
      else
        IO.puts("should NEVER happen")
        acc
      end
    end)
  end

  defp convert_to_digit(digit) do
    Map.get(@digit_map, digit, digit)
  end
end

sum = CalibrationSum.run("./input/day1-1.real")
IO.puts("The sum of all calibration values is: #{sum}")
