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
Get emails from a file
"""
def get_emails(in_filename, out_filename) do
  emails =
    in_filename
    |> File.stream!()
    |> Enum.map(&email_from_line/1)
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(&hd/1)
    |> Enum.join("\n")
  File.write(out_filename, emails)
end


def email_from_line(line) do
  Regex.run(~r|\w+(?:\.\w+)*@\w+(?:\.\w+)*\.[a-z]{2,4}|, line)
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




# Regex.run(~r|[\{\}\[\]\,]|, line) <- Special Characters. Brackets, keys, and commas
# Regex.run(~r|[{}[\],]|, line) <- Special Characters. Brackets, keys, and commas V.2
# Regex.run(~r|((-?\d+)((.)?\d+)([eE][+-]?\d)?)|) <- Digits and Numbers
# Regex.run(~r|((\")\w+([-:_]?\w+)+(\"\s*\:))|) <- Keys
# Regex.run(~r|(\"([\w\d\/]+)([\s\w\d\/\:\.\-\=\;\*\@\(\)\?\+]*)\")|) <- Strings
# Regex.run(~r|(\"([-\s\w\/:.=;*@()?+]*)\")|) <- Strings V.2
# (true|false|True|False|null|NULL) <- True/False/NULL


# Regex.run(~r|[\{\}\[\]\,\:]|, line)
# # Regex.run(~r|^\"[a-zA-Z\\.\\:\\/\\?\\!\\,\\;\\'\\&\\*\\-\\+\\@\\=\\0-9\\s]*?\"\\:[\\s]?|, line)
# # Regex.run(~r|^\"[a-zA-Z\\.\\:\\/\\?\\!\\,\\;\\'\\&\\*\\-\\+\\@\\=\\0-9\\s]*?\"|, line)
# # Regex.run(~r|(-)?[\\d\\.]+([eE][-+]?[\\d]*)?|, line)
# # Regex.run(~r/^true|false|True|False|null|NULL/, line)
# Regex.run(~r|^(\s+)|, line)
# # Regex.run(~r|\w+(?:\.\w+)*@\w+(?:\.\w+)*\.[a-z]{2,4}|, line)
