defmodule Reto1 do
  @doc """
Get emails from a file
"""
  def get_emails(in_filename, out_filename) do
    emails =
      in_filename
      |> File.stream!()
      |> Enum.map(&start_recognition/1)
      # |> IO.inspect()
      # |> Enum.filter(&(&1 != nil))
      # |> Enum.map(&hd/1)
      |> Enum.join("")
    File.write(out_filename, emails)
  end

  def start_recognition(line) do
    recognize_values(line, "")
  end
  def recognize_values(line, spanClasses) do
    if String.length(line) == 0 do
      spanClasses
    else
      tuple = email_from_line(line)
      recognize_values(Atom.to_string(elem(tuple, 0)), spanClasses <> Atom.to_string(elem(tuple, 1)))
    end

  end

  def email_from_line(line) do
    empty = Regex.run(~r|\s+|, line, [capture: :first, return: :index])
    keys = Regex.run(~r|((\")\w+([-:_]?\w+)+(\"\s*\:))|, line, [capture: :first, return: :index])
    strings = Regex.run(~r|(\"([-\s\w\/:.,=;*&@()?+']*)\")|, line, [capture: :first, return: :index])
    numbers = Regex.run(~r|((-?\d*)((.)?\d)([eE][+-]?\d)?)|, line, [capture: :first, return: :index])
    bools = Regex.run(~r/(true|false|True|False|null|NULL)/, line, [capture: :first, return: :index])
    separations = Regex.run(~r|[{}[\],]|, line, [capture: :first, return: :index])
    cond do
      empty != nil -> function(List.first(empty), 'empty_space', line)
      keys != nil -> function(List.first(keys), 'object_key', line)
      strings != nil -> function(List.first(strings), 'string', line)
      numbers != nil -> function(List.first(numbers), 'number', line)
      bools != nil -> function(List.first(bools), 'reserved-word', line)
      separations != nil -> function_punctuation(List.first(separations), 'puctuation', line)
    end
  end


  def function(index, value, line) do
    capture = String.slice(line, elem(index, 0), elem(index, 1))
    span = create_span(capture, value)
    line = String.replace(line, capture, "")
    tuple = {String.to_atom(line), String.to_atom(span)}
    tuple
  end

  def function_punctuation(index, value, line) do
    IO.inspect(index)
    capture = String.slice(line, elem(index, 0), elem(index, 1))
    span = create_span(capture, value)
    line = String.replace_prefix(line, capture, "")
    IO.inspect(line)
    tuple = {String.to_atom(line), String.to_atom(span)}
    tuple
  end


  def create_span(line, value_found) do
    "<span class=\"#{value_found}\">#{line}</span>"
  end

end
