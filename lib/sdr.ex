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
  Simple encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.simple(0, 0, 100, 100, 21, 72)
      #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>
  ```

  ```elixir
      iex(1)> Sdr.simple(0, 0, 100, 100, 21, 73)
      #MapSet<[73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93]>
  ```
  """

  def simple(start, min, max, buckets, w, v) do
    g = w - 1 + start
    i = trunc(:math.floor(buckets * (v-min)) / max - min)
    MapSet.new(start..g, fn x -> i + x end)
  end

  @doc """
  Infinite encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.infinite(21, 72)
      #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>
  ```

  ```elixir
      iex(1)> Sdr.infinite(21, 773)
      #MapSet<[773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793]>
  ```
  """

  def infinite(w, v) do
    g = w - 1
    MapSet.new(0..g, fn x -> v + x end)
  end

  @doc """
  Hash encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.hash(3, 732)
      #MapSet<["6C29793A140A811D0C45CE03C1C93A28", "BA3866600C3540F67C1E9575E213BE0A", "E995F98D56967D946471AF29D7BF99F1"]>
  ```
  """

  def hash(w, v) do
    g = w - 1
    MapSet.new(0..g, fn x -> :crypto.hash(:md5, Integer.to_string(v + x)) |> Base.encode16 end)
  end


  @doc """
  Log encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.log(0, 21, 1)
      #MapSet<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]>
  ```

  ```elixir
      iex(1)> Sdr.log(0, 21, 10)
      #MapSet<[2302, 2303, 2304, 2305, 2306, 2307, 2308, 2309, 2310, 2311, 2312, 2313, 2314, 2315, 2316, 2317, 2318, 2319, 2320, 2321, 2322]>
  ```

  ```elixir
      iex(1)> Sdr.log(0, 21, 100)
      #MapSet<[4605, 4606, 4607, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625]>
  ```
  """

  def log(start, w, v) do
    g = w - 1 + start
    MapSet.new(start..g, fn x -> trunc(:math.log(v) * 1000) + x end)
  end

  @doc """
  Delta encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.delta(0, 10, 75, 82)
      #MapSet<[7, 8, 9, 10, 11, 12, 13, 14, 15, 16]>
  ```

  ```elixir
      iex(1)> Sdr.delta(0, 10, 78, 82)
      #MapSet<[4, 5, 6, 7, 8, 9, 10, 11, 12, 13]>
  ```

  ```elixir
      iex(1)> Sdr.delta(0, 10, 78, 72)
      #MapSet<[-6, -5, -4, -3, -2, -1, 0, 1, 2, 3]>
  ```
  """

  def delta(start, w, prev, curr) do
    g = w - 1 + start
    d = curr - prev
    MapSet.new(start..g, fn x -> d + x end)
  end

  @doc """
  Cyclic encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 2)
      #MapSet<[4, 5, 6, 7, 8, 9, 10, 11]>
  ```

  ```elixir
      iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 5)
      #MapSet<[10, 11, 12, 13, 14, 15, 16, 17]>
  ```
  ```elixir
      iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 15)
      #MapSet<[10, 11, 12, 13, 14, 15, 16, 17]>
  ```
  """

  def cyclic(start, min, max, buckets, w, input) do
    g = w - 1 + start
    v = rem(input, max)
    n = buckets + start
    i = trunc(:math.floor(buckets * (v-min)) / max - min)
    MapSet.new(start..g, fn x -> cycle(i, x, n) end)
  end

  defp cycle(i, x, n) do
    if (i + x) > n do
        i + x - n; 
    else
      i + x;
    end
  end

  @doc """
  Multi encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.multi([[0,0,100,1000,21,72],[1022,0,10,200,4,5]])
      #MapSet<[720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 1122, 1123, 1124, 1125]>

  ```

  ```elixir
      iex(1)> Sdr.multi([[0,0,100,1000,21,73],[1022,0,10,200,4,5.1]])
      #MapSet<[730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 1123, 1124, 1125, 1126]>
  ```
  """

  def multi(inputs) do
    Enum.map(inputs, fn x -> combine(x) end)
    |> List.flatten()
    |> MapSet.new()
  end

  defp combine(input) do
    acc = Enum.at(input, 0)    
    min = Enum.at(input, 1)
    max = Enum.at(input, 2)
    buckets = Enum.at(input, 3)
    w = Enum.at(input, 4)
    v = Enum.at(input, 5)
    g = w - 1 + acc
    i = trunc(:math.floor(buckets * (v-min)) / max - min)
    Enum.map(acc..g, fn x -> i + x end)
  end

  @doc """
  Merge encoder.

  ## Examples

  ```elixir
      iex(1)> Sdr.simple(0, 0, 100, 100, 21, 72) |> Sdr.merge(Sdr.cyclic(122, 0, 24, 24, 8, 4))
      #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 126, 127, 128, 129, 130, 131, 132, 133]>
  ```
  """

  def merge(encoded1, encoded2) do
    MapSet.union(encoded1, encoded2)
  end
end

