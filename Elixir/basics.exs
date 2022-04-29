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

  def fact_tail(x), do: do_fact_tail(x, 1)
  defp do_fact_tail(0, a), do: a
  defp do_fact_tail(x, a), do: do_fact_tail(x-1, x*a)

end


=== EBNF ===
MODULE ::= defmodule {A-Z}{a-z} do \n\t [{FUNCTIONS}] end
FUNCTIONS:: (def | defp) {a-z}'('[VAR[',' VARS]]')'',' do: CODE


serverless create --template aws-nodejs

serverless confic credentials --
