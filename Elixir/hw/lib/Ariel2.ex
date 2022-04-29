defmodule Hw.Ariel2 do
  @moduledoc """
  Functions to work with lists in Elixir
  """

  @doc """
  Function 8.-
  Function pack receives a list as input. Returns a list that groups consecutive elements as small lists
  Example: pack(a a a a b c c a a d e e e e) -> ((a a a a) (b) (c c) (a a) (d) (e e e e))
  """

  # """
  # def pack(list), do: do_pack(list, [], [])
  # defp do_pack([], result, _value_list), do: Enum.reverse(result)

  # # List only has one item
  # defp do_pack([head | []], result, value_list), do: do_pack([], [[head | value_list] | result], [])

  # # List has at least two consecutive equal elements at this point
  # defp do_pack([head, head | tail], result, value_list), do: do_pack([head | tail], result, [head | value_list])

  # # List doesn't have consecutive elements at this point
  # defp do_pack([head | tail], result, value_list), do: do_pack(tail, [[head | value_list] | result], [])
  # """


  def pack(list), do: do_pack(list, [])
  defp do_pack([], result), do: Enum.reverse(result)

  # First element in input is equal to those in the head of the result
  defp do_pack([head | tail], [[head | tltmp] | tlrs]), do: do_pack(tail, [[head, head | tltmp] | tlrs])

  # The first element in input is not in result
  defp do_pack([head | tail], result), do: do_pack(tail, [[head] | result])

end
