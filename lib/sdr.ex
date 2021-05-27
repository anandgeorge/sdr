defmodule Sdr do
  @moduledoc """
  SDR is an Elixir library for Sparse Distributed Representations
  """

  defp factorial(n), do: factorial(n, 1)
  defp factorial(0, acc), do: acc
  defp factorial(n, acc) when n > 0, do: factorial(n - 1, acc * n)


  @doc """
  Capacity of a SDR.

  ## Examples

    ```elixir
        iex(1)> Sdr.capacity(2048, 6)
        101733385755251712
    ```
  """

  def capacity(n, w) do
    factorial(n) |> div(factorial(w) * factorial(n-w))
  end

  @doc """
  Sparsity of a SDR.

  ## Examples

    ```elixir
        iex(1)> Sdr.sparsity(2048, 6)
        0.0029296875
    ```
  """

  def sparsity(n, w) do
    w / n
  end
end
