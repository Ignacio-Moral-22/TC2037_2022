# Functions to work with files
#
# Ignacio Joaquin Moral
# A01028470
# 03-05-2022


# File.read(source) -> Always throws something, even an error tuple
# File.read!(source) -> If not found, throws an exception
# 3..8 -> 3, 4, 5, 6, 7, 8
# Enu,.map(data, fn x -> :math.sqrt(x) end)

defmodule Tfiles do

def spaces_to_dashes(in_filename, out_filename) do
  # Single expression of nested calls, kinda ugly but it works
  File.write(out_filename, Enum.join(Enum.map(Enum.map(File.stream!(in_filename), &String.split/1), fn line -> Enum.join(line, "-") end), "\n"))

  # Using weird temps
  temp1 = File.stream!(in_filename)
  temp2 = Enum.map(temp1, &String.split/1)
  temp3 = Enum.map(temp2, fn line -> Enum.join(line, "-") end)
  temp4 = Enum.join(temp3, "\n")
  File.write(out_filename, temp4)

  #Using pipe operator to link the alls
  text =
    in_filename
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.map(&(Enum.join(&1, "-")))
    |> Enum.join("\n")

  File.write(out_filename, text)


end

@doc """
Examples of a map use
"""
def sqrt_list(list) do
  # Provide the function to map as a lambda function
  Enum.map(list, fn x -> :math.sqrt(x) end)
  # Shorthand (Might be wrong, ask Gil later)
  Enum.map(list, &(:math.sqrt(&1)))
  # Provide the reference to a function
  Enum.map(list, &:math.sqrt/1)

  # Alternative syntax: list comprehension
  for x <- list, do: :math.sqrt(x)
end


end
