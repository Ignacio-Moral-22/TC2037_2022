# Functions with Lists in Elixir
#
# Ignacio Joaquin Moral
# 26-04-2022

defmodule TLists do
  @moduledoc """
  Functions to work with lists
  """
  @doc """
  Sum all the values in a given list
  """

  def sumList(list) do
    if list == [] do
      0
    else
      hd(list) + sumList(tl(list))
    end
  end

  def sumTail(list), do: do_sumTail(list, 0)
  defp do_sumTail([], sumValue), do: sumValue
  defp do_sumTail(list, sumValue), do: do_sumTail(tl(list), hd(list) + sumValue)

  @doc """
  Sum all values in a list using pattern matching
  """
  def sum_3(list), do: do_sum_3(list, 0)
  defp do_sum_3([], result), do: result
  defp do_sum_3([head | tail], result), do: do_sum_3(tail, result + head)

  @doc """
  Filter a list and keep only positive elements, using "guards"
  """
  def positives(list), do: do_positives(list, [])
  defp do_positives([], result), do: Enum.reverse(result)
  defp do_positive([head | tail], result) when head < 0, do: do_positive(tail, result)
  defp do_positive([head | tail], result), do: do_positive(tail, [head | result])

  def positives_2(list, result \\ [])
  def positives_2([], result), do: Enum.reverse(result)
  def positives_2([head | tail], result) when head < 0, do: positives_2(tail, result)
  def positives_2([head | tail], result), do: positives_2(tail, [head | result])
end

# if data = [4, 5, 6, 7, 8]
# and head & tail -> MatchError
# [head | tail] = data -> [4, 5, 6, 7, 8]
# [head | tail] = 456 -> MatchError
# head -> 4, tail -> [5, 6, 7, 8]
# Assings values to a pattern matching
# THe "=" is matching the "[]" pattern

# if data = [4, 5, 6]
# [3 | data] -> [3, 4, 5, 6]
# [data | 3] -> [[4, 5, 6] | 3]
# data ++ data -> [4, 5, 6, 4, 5, 6]
