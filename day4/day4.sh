#!env /bin/sh
set -xe
mix format lib/day4.ex
mix format mix.exs
mix escript.build && ./day4 --file ./input/day4-1.real
#mix escript.build && ./day4 --file ./input/day4-1.example
