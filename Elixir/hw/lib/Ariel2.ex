# Homework 2.2 .- Functional Programming Part 2
# Class TC2037.600 - Teacher Gilberto Echeverria Furio
# Students:
# Ignacio Joaquin Moral - A01028470
#
#
# Last edited: 09-05-2022 - dd-mm-yyyy

defmodule Hw.Ariel2 do
  @moduledoc """
  Functions to work with lists in Elixir.
  Functional Programming.
  """

  @doc """
  Function 1.-
  Function insert receives a number and an ordered list as input. Returns the list with the number added in the correct position.
  Examples:
  insert(14 ()) => (14)
  insert(3 (1 4 5 6)) => (1 3 4 5 6)
  """

  # Call to private functons
  def insert(list, value), do: do_insert(list, value, [])
  # List is empty, return inverse of the 'result list'. This function is only called with two values intentionally
  defp do_insert([], [head | tail]), do: Enum.reverse([head | tail])

  # List has at least one value, and the result has at least one value.
  defp do_insert([head | tail], [headResult | tailResult]), do: do_insert(tail, [head | [headResult | tailResult]])

  # List is empty, but there's the value that needs to be added
  defp do_insert([], value, []), do: do_insert([], [value |[]])

  # Empty list having at least one value in the result
  defp do_insert([], value, [head | tail]), do: do_insert([], [value |[head | tail]])

  # If the first value of the list is lower than the value waiting to be added
  defp do_insert([head | tail], value, result) when head < value, do: do_insert(tail, value, [head | result])

  # If the first value of the list is equal to the value waiting to be added, return the list, add the value. Now it only calls for the 'two value' function
  defp do_insert([head | tail], value, result) when head == value, do: do_insert([head | tail], [value | result])

  # If the first value of the list is higher than the value waiting to be added, return the list, and add the value. Now it only calls for the 'two value' function
  defp do_insert([head | tail], value, result) when head > value, do: do_insert([head | tail], [value | result])

  @doc """
  Function 2.-
  Function insertion_sort receives a unordered number list as input. Returns the list in ascending order. Only order with the function insert created previously.
  Examples:
  insertion_sort([4, 3, 6, 8, 3, 0, 9, 1, 7]) => (0 1 3 3 4 6 7 8 9)
  insertion_sort([5, 5, 5, 1, 5, 5, 5]) => (1 5 5 5 5 5 5)
  """

  # Call to private functions. Send the list and an empty list.
  def insertion_sort(list), do: do_insertion_sort(list, [])
  # If the list is empty, send the result
  defp do_insertion_sort([], result), do: result
  # If the list only has one item, do "insert" with the head of the list, and add it to the result
  defp do_insertion_sort([head | []], result), do: do_insertion_sort([], insert(result, head))
  # Otherwise, return the tail of the list, and "insert" the head to the result
  defp do_insertion_sort([head | tail], result), do: do_insertion_sort(tail, insert(result, head))


  @doc """
  Function 3.-
  Function rotate_left takes a list and a whole number as input.
  Returns the list after rotating the values 'number' times to the left.
  If the number is negative, it rotates to the right.
  Example:

  rotate_left([a, b, c, d, e, f, g], 1) => (b c d e f g a)
  rotate_left([a, b, c, d, e, f, g], -3) => (e f g a b c d)
  """

  def rotate_left(list, number), do: do_rotate_left(list, number)

  # If the list is empty, return empty. Number doesn't matter.
  defp do_rotate_left([], _number), do: []
  # If the number is 0, just return the list
  defp do_rotate_left(list, number) when number==0, do: list
  # If the number is higher than 0, add the tail of the list to a new [head] list.
  defp do_rotate_left([head | tail], number) when number>0, do: do_rotate_left(tail ++ [head], number-1)
  # When the number is lower than 0, add the last element to the list at the beginning, add it to the "head", and all that add it to the list "List - lastElement".
  # There might be a better form to do it, but I'm not sure what it is.
  defp do_rotate_left([head | tail], number) when number<0, do: do_rotate_left([List.last(tail)] ++ [head] ++ List.delete_at(tail, -1), number+1)


  @doc """
  Function 8.-
  Function pack receives a list as input. Returns a list that groups consecutive elements as small lists
  Example: pack(a a a a b c c a a d e e e e) -> ((a a a a) (b) (c c) (a a) (d) (e e e e))
  """

  def pack(list), do: do_pack(list, [], [])
  defp do_pack([], result, _value_list), do: Enum.reverse(result)

  # List only has one item
  defp do_pack([head | []], result, value_list), do: do_pack([], [[head | value_list] | result], [])

  # List has at least two consecutive equal elements at this point
  defp do_pack([head, head | tail], result, value_list), do: do_pack([head | tail], result, [head | value_list])

  # List doesn't have consecutive elements at this point
  defp do_pack([head | tail], result, value_list), do: do_pack(tail, [[head | value_list] | result], [])


  @doc """
  Second way to do function 8.

  # def pack(list), do: do_pack(list, [])
  # defp do_pack([], result), do: Enum.reverse(result)

  # # First element in input is equal to those in the head of the result
  # defp do_pack([head | tail], [[head | tltmp] | tlrs]), do: do_pack(tail, [[head, head | tltmp] | tlrs])

  # # The first element in input is not in result
  # defp do_pack([head | tail], result), do: do_pack(tail, [[head] | result])

  """

  @doc """
  Function 10.-
  Function encode receives a list as input.
  Returns a list of consecutive elements in the form of {n, e}, where 'n' is the number of consecutive times 'e' appears.
  Examples:
  encode([a, a, a, a, b, c, c, a, a, d, e, e, e, e]) => ({4, a} {1, b} {2, c} {2, a} {1, d} {4, :e})
  encode([1, 2, 3, 4, 5]) => ({1, 1} {1, 2} {1, 3} {1, 4} {1, 5})
  """

  def encode(list), do: do_encode(list, [], [], 1)
  # Empty List, reverse the result, and that's it
  defp do_encode([], result, _value_list, _value_count), do: Enum.reverse(result)
  # List only has one item. Add the last element with the count. Reset the count.
  defp do_encode([head | []], result, [head | _value_list], value_count), do: do_encode([], [{value_count, head} | result], [], 1)
  # List has at least two consecutive equal elements at this point. Add to a list, we'll add the "pair" later.
  defp do_encode([head, head | tail], result, value_list, value_count), do: do_encode([head | tail], result, [head | value_list], value_count+1)
  # List doesn't have consecutive elements at this point. Add the first element with the count, reset the count
  defp do_encode([head | tail], result, _value_list, value_count), do: do_encode(tail, [{value_count, head} | result], [], 1)


end
