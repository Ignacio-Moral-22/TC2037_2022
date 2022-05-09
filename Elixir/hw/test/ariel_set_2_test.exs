#    Tests for the set of problems by Ariel Ortiz
#    Applications of the general concepts of functional programming
#
#    Gilberto Echeverria
#    2022_03_04

defmodule Hw.Ariel2Test do
  use ExUnit.Case
  alias Hw.Ariel2

  # Functions

  test "test insert" do
    assert Ariel2.insert([], 14) == [14]
    assert Ariel2.insert([5, 6, 7, 8], 4) == [4, 5, 6, 7, 8]
    assert Ariel2.insert([1, 3, 6, 7, 9, 16], 5) == [1, 3, 5, 6, 7, 9, 16]
    assert Ariel2.insert([1, 5, 6], 10) == [1, 5, 6, 10]
  end

  test "test insertion_sort" do
    assert Ariel2.insertion_sort([]) == []
    assert Ariel2.insertion_sort([4, 3, 6, 8, 3, 0, 9, 1, 7]) == [0, 1, 3, 3, 4, 6, 7, 8, 9]
    assert Ariel2.insertion_sort([1, 2, 3, 4, 5, 6]) == [1, 2, 3, 4, 5, 6]
    assert Ariel2.insertion_sort([5, 5, 5, 1, 5, 5, 5]) == [1, 5, 5, 5, 5, 5, 5]
  end

  test "test rotate_left" do
    assert Ariel2.rotate_left([], 5) == []
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], 0) == [:a, :b, :c, :d, :e, :f, :g]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], 1) == [:b, :c, :d, :e, :f, :g, :a]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], -1) == [:g, :a, :b, :c, :d, :e, :f]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], 3) == [:d, :e, :f, :g, :a, :b, :c]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], -3) == [:e, :f, :g, :a, :b, :c, :d]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], 8) == [:b, :c, :d, :e, :f, :g, :a]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], -8) == [:g, :a, :b, :c, :d, :e, :f]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], 45) == [:d, :e, :f, :g, :a, :b, :c]
    assert Ariel2.rotate_left([:a, :b, :c, :d, :e, :f, :g], -45) == [:e, :f, :g, :a, :b, :c, :d]
  end

  test "test pack" do
    assert Ariel2.pack([]) == []
    assert Ariel2.pack([:a]) == [[:a]]

    assert Ariel2.pack([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
             [[:a, :a, :a, :a], [:b], [:c, :c], [:a, :a], [:d], [:e, :e, :e, :e]]

    assert Ariel2.pack([1, 2, 3, 4, 5]) == [[1], [2], [3], [4], [5]]
    assert Ariel2.pack([9, 9, 9, 9, 9]) == [[9, 9, 9, 9, 9]]
  end

  test "test encode" do
    assert Ariel2.encode([]) == []
    assert Ariel2.encode([:a]) == [{1, :a}]

    assert Ariel2.encode([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]) ==
             [{4, :a}, {1, :b}, {2, :c}, {2, :a}, {1, :d}, {4, :e}]

    assert Ariel2.encode([1, 2, 3, 4, 5]) == [{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}]
    assert Ariel2.encode([9, 9, 9, 9, 9]) == [{5, 9}]
  end

end
