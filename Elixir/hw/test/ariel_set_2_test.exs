#    Tests for the set of problems by Ariel Ortiz
#    Applications of the general concepts of functional programming
#
#    Gilberto Echeverria
#    2022_03_04

defmodule Hw.Ariel2Test do
  use ExUnit.Case
  alias Hw.Ariel2

  # Functions

  test "test pack" do
    assert Ariel2.pack([]) == []
    assert Ariel2.pack([:a]) == [[:a]]

    assert Ariel2.pack([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
             [[:a, :a, :a, :a], [:b], [:c, :c], [:a, :a], [:d], [:e, :e, :e, :e]]

    assert Ariel2.pack([1, 2, 3, 4, 5]) == [[1], [2], [3], [4], [5]]
    assert Ariel2.pack([9, 9, 9, 9, 9]) == [[9, 9, 9, 9, 9]]
  end

  # test "test compress" do
  #   assert Ariel2.compress([]) == []
  #   assert Ariel2.compress([:a]) == [:a]

  #   assert Ariel2.compress([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
  #            [:a, :b, :c, :a, :d, :e]

  #   assert Ariel2.compress([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
  #   assert Ariel2.compress([9, 9, 9, 9, 9]) == [9]
  # end

  # test "test encode" do
  #   assert Ariel2.encode([]) == []
  #   assert Ariel2.encode([:a]) == [{1, :a}]

  #   assert Ariel2.encode([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
  #            [{4, :a}, {1, :b}, {2, :c}, {2, :a}, {1, :d}, {4, :e}]

  #   assert Ariel2.encode([1, 2, 3, 4, 5]) == [{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}]
  #   assert Ariel2.encode([9, 9, 9, 9, 9]) == [{5, 9}]
  # end

  # test "test encode_modified" do
  #   assert Ariel2.encode_modified([]) == []
  #   assert Ariel2.encode_modified([:a]) == [:a]

  #   assert Ariel2.encode_modified([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
  #            [{4, :a}, :b, {2, :c}, {2, :a}, :d, {4, :e}]

  #   assert Ariel2.encode_modified([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
  #   assert Ariel2.encode_modified([9, 9, 9, 9, 9]) == [{5, 9}]
  # end

  # test "test decode" do
  #   assert Ariel2.decode([]) == []
  #   assert Ariel2.decode([:a]) == [:a]

  #   assert Ariel2.decode([{4, :a}, :b, {2, :c}, {2, :a}, :d, {4, :e}]) ==
  #            [:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]

  #   assert Ariel2.decode([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
  #   assert Ariel2.decode([{5, 9}]) == [9, 9, 9, 9, 9]
  # end
end
