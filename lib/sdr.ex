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

  @doc """
  Union of two SDRs.

  ## Examples

    ```elixir
        iex(1)> Sdr.union(MapSet.new([1, 2]), MapSet.new([2, 3]))
        #MapSet<[1, 2, 3]>
    ```
    Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.
  """

  def union(m1, m2) do
    MapSet.union(m1, m2)
  end

  @doc """
  Union of two random similar SDRs given their number of bits n and the number of on bits w.
  """

  def unionr(n, w) do
    MapSet.union(MapSet.new(1..w, fn _x -> :crypto.rand_uniform(0,n) end), MapSet.new(1..w, fn _x -> :crypto.rand_uniform(0,n) end))
  end

  @doc """
  Linear encoder.

  ## Examples

    ```elixir
        iex(1)> Sdr.simple(0, 100, 1, 21, 72)
        #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>
    ```

    ```elixir
        iex(1)> Sdr.simple(0, 100, 1, 21, 73)
        #MapSet<[73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93]>
    ```
    Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.
  """

  def simple(min, max, lc, w, v) do
    range = max - min
    split = range / lc
    g = w - 1
    _n = trunc(split + g)
    i = trunc(:math.floor(split * (v-min)) / range)
    MapSet.new(0..g, fn x -> i + x end)
  end

  @doc """
  Hash encoder.

  ## Examples

    ```elixir
        iex(1)> Sdr.hash(0, 100, 1, 3, 72)
        #MapSet<["32BB90E8976AAB5298D5DA10FE66F21D", "AD61AB143223EFBC24C7D2583BE69251", "D2DDEA18F00665CE8623E36BD4E3C7C5"]>
    ```
    Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.
  """

  def hash(min, max, lc, w, v) do
    range = max - min
    split = range / lc
    g = w - 1
    _n = trunc(split + g)
    i = trunc(:math.floor(split * (v-min)) / range)
    MapSet.new(0..g, fn x -> :crypto.hash(:md5, Integer.to_string(i + x)) |> Base.encode16 end)
  end

end

