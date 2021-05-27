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

  @doc """
  Overlap of two SDRs.

  ## Examples

    ```elixir
        iex(1)> Sdr.overlap(MapSet.new([1, 2]), MapSet.new([2, 3]))
        #MapSet<[2]>
    ```
    Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.
  """

  def overlap(m1, m2) do
    MapSet.intersection(m1, m2)
  end

  @doc """
  Overlap of two random similar SDRs given their number of bits n and the number of on bits w.
  """

  def overlapr(n, w) do
    MapSet.intersection(MapSet.new(1..w, fn _x -> :crypto.rand_uniform(0,n) end), MapSet.new(1..w, fn _x -> :crypto.rand_uniform(0,n) end))
  end
end

