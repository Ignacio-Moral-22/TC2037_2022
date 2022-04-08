# First Functions in Elixir

# Ignacio Moral
# 08 - 04 - 2022

defmodule Learn do
  @doc """
  Compute the factorial of x value
  """
  def fact(x) do

    if x==0 do
      1
    else
      x * fact(x-1)
    end

  end

  def fact_tail(x, a) do
    if x==0 do
      a
    else
      fact_tail(x-1, x*a)
    end
  end

  def tail(x) do
    fact_tail(x, 1)
  end

end
