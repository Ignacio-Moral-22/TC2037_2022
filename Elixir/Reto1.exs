defmodule Reto1 do
  @doc """
Get emails from a file
"""
  def get_emails(in_filename, out_filename) do
    emails =
      in_filename
      |> File.stream!()
      |> Enum.map(&email_from_line/1)
      |> IO.inspect()
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&hd/1)
      |> Enum.join("\n")
    File.write(out_filename, emails)
  end


  def email_from_line(line) do
    cond do
      Regex.run(~r|[{}[\],]|, line)!=nil ->
        Regex.run(~r|[{}[\],]|, line)
      Regex.run(~r|((-?\d+)((.)?\d+)([eE][+-]?\d)?)|, line)!= nil ->
        Regex.run(~r|((-?\d+)((.)?\d+)([eE][+-]?\d)?)|, line)
      Regex.run(~r|((\")\w+([-:_]?\w+)+(\"\s*\:))|, line)!=nil ->
        Regex.run(~r|((\")\w+([-:_]?\w+)+(\"\s*\:))|, line)
      Regex.run(~r|(\"([-\s\w\/:.=;*@()?+]*)\")|, line)!=nil ->
        Regex.run(~r|(\"([-\s\w\/:.=;*@()?+]*)\")|, line)
      # Regex.run(~r|(true|false|True|False|null|NULL)|, line)!=nil ->
      #   Regex.run(~r|(true|false|True|False|null|NULL)|, line)
      Regex.run(~r|\s+|, line)!=nil ->
        Regex.run(~r|\s+|, line)
    end
  end

  # def get_jsons(in_filename, out_filename) do
  #   expressions =
  #     in_filename
  #     |> File.stream!()
  #     |> Enum.map(&expression/1)
  #     |> Enum.filter(&(&1 != nil))
  #     |> Enum.map(&hd/1)
  #     |> Enum.join("\n")
  #   File.write(out_filename, expressions)
  # end
end
