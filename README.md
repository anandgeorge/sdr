# Sparse Distributed Representations (SDR)

According to recent findings in neuroscience, the brain uses SDRs to process information. This is true for all mammals, from mice to humans. The SDRs visualize the information processed by the brain at a given moment, each active cell bearing some semantic aspect of the overall message.

Sparse means that only a few of the many (thousands of) neurons are active at the same time, in contrast to the typical “dense” representation, in computers, of a few bits of 0s and 1s.

Distributed means that not only are the active cells spread across the representation, but the significance of the pattern is too. This makes the SDR resilient to the failure of single neurons and allows sub-sampling.

As each bit or neuron has a meaning, if the same bit is active in two SDRs, it means that they are semantically similar: that is the key to our computational approach.

## Installation

The package can be installed by adding `sdr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sdr, "~> 0.1.0"}
  ]
end
```

## Usage

#### capacity(n, w)

where n is the total number of bits and w is the number of "on" bits

#### sparsity(n, w)

where n is the total number of bits and w is the number of "on" bits

#### overlap(m1, m2)

where m1 and m2 are MapSets of similar sizes. Returns a MapSet. 
Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.

#### overlapr(n, w)

where n is the total number of bits and w is the number of "on" bits. Overlap returns a MapSet that is the overlap of two randomly generated MapSets with the specified number of bits and "on" bits.

#### union(m1, m2)

where m1 and m2 are MapSets of similar sizes. Returns a MapSet. 
Use MapSet.size/1 to get the length of the MapSet. Use MapSet.to_list/1 to convert it to a list.

#### unionr(n, w)

where n is the total number of bits and w is the number of "on" bits. Union returns a MapSet that is the union of two randomly generated MapSets with the specified number of bits and "on" bits.

### Examples

```elixir

	iex(1)> Sdr.capacity(2048, 6)
	101733385755251712

	iex(1)> Sdr.sparsity(2048, 6)
	0.0029296875

	iex(1)> Sdr.overlap(MapSet.new([1, 2]), MapSet.new([2, 3]))
	#MapSet<[2]>

	iex(1)> Sdr.union(MapSet.new([1, 2]), MapSet.new([2, 3]))
	#MapSet<[1, 2, 3]>
```
## Encoders

An encoder converts a value to an SDR.

There are a few important aspects that need to be considered when encoding data

1. Semantically similar data should result in SDRs with overlapping active bits.
2. The same input should always produce the same SDR as output.
3. The output should have the same dimensionality (total number of bits) for all inputs.
4. The output should have similar sparsity for all inputs and have enough one-bits to handle noise and subsampling.

### Simple encoder

A simple encoder first splits the range of values into sequential buckets of a specified size and then maps the input range over the specified range of SDR.

#### simple(start, min, max, buckets, w, input)

where min and max and the minimum and maximum values of the range, buckets represents how many parts the range should be divided into, w represents the size of each bucket (number of bits in each bucket) start represents the lower limit of the encoded range and input represents the value to be encoded. It returns the encoded value as a MapSet.

#### Examples

```elixir

    iex(1)> Sdr.simple(0, 0, 100, 100, 21, 72)
    #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>

    iex(1)> Sdr.simple(0, 0, 100, 100, 21, 73)
    #MapSet<[73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93]>
```

### Infinite encoder

A infinite encoder creates an encoding that results in a fixed number of bits for each value. They are sequentially encoded so semantically similar. Unlike the simple encoder they can cover an infinite range of values.

#### infinite(w, input)

where w represents the number of bits in each encoded output and input is the value to be encoded. It returns the encoded value as a MapSet.

#### Examples

```elixir

    iex(1)> Sdr.infinite(21, 72)
    #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>

    iex(1)> Sdr.infinite(21, 773)
    #MapSet<[773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793]>
```

### Hash encoder

A hash encoder is similar to an infinite encoder except that the output is a hash of the encoded bits.

#### hash(w, input)

where w represents the number of bits in each encoded output and input is the value to be encoded. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.hash(3, 72)
    #MapSet<["32BB90E8976AAB5298D5DA10FE66F21D", "AD61AB143223EFBC24C7D2583BE69251", "D2DDEA18F00665CE8623E36BD4E3C7C5"]>
```

### Log encoder

A log encoder encodes the log of the input value. This encoder is sensitive to small changes for small numbers and less sensitive to large values.

#### log(start, w, input)

where w represents the number of bits in each encoded output start represents the lower limit of the encoded range and input is the value to be encoded. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.log(0, 21, 1)
    #MapSet<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]>

    iex(1)> Sdr.log(0, 21, 10)
    #MapSet<[2302, 2303, 2304, 2305, 2306, 2307, 2308, 2309, 2310, 2311, 2312, 2313, 2314, 2315, 2316, 2317, 2318, 2319, 2320, 2321, 2322]>

    iex(1)> Sdr.log(0, 21, 100)
    #MapSet<[4605, 4606, 4607, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625]>
```

### Delta encoder

A delta encoder encodes the difference between the current and the previous input values. A delta encoder is designed to capture the semantics of the change in a value rather than the value itself. This technique is useful for modeling data that has patterns that can occur in different value ranges and may be helpful to use in conjunction with a regular numeric encoder. 

#### delta(start, w, prev, curr)

where w represents the number of bits in the encoded output, curr and prev represents the current and previous inputs respectively and start represents the lower limit of the encoded range of the values to be encoded. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.delta(0, 10, 75, 82)
    #MapSet<[7, 8, 9, 10, 11, 12, 13, 14, 15, 16]>

    iex(1)> Sdr.delta(0, 10, 78, 82)
    #MapSet<[4, 5, 6, 7, 8, 9, 10, 11, 12, 13]>

    iex(1)> Sdr.delta(0, 10, 78, 72)
    #MapSet<[-6, -5, -4, -3, -2, -1, 0, 1, 2, 3]>
```

### Cyclic encoder

A cyclic encoder is similar to a simple encoder except that values in this case are cyclic. Day of the week, hour of the day etc. are examples of cyclic encoders. The encoder ensures overlap of values between the end of the range and start of the range. 

#### cyclic(start, min, max, buckets, w, input)

where min and max and the minimum and maximum values of the range, buckets represents how many parts the range should be divided into, w represents the size of each bucket (number of bits in each bucket) start represents the lower limit of the encoded range and input the value to be encoded. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 2)
    #MapSet<[4, 5, 6, 7, 8, 9, 10, 11]>

    iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 5)
    #MapSet<[10, 11, 12, 13, 14, 15, 16, 17]>

    iex(1)> Sdr.cyclic(0, 0, 10, 20, 8, 15)
    #MapSet<[10, 11, 12, 13, 14, 15, 16, 17]>
```

### Multi encoder

A multi encoder combines a set of related values into a single encoded value. A typical input would be the temperature at a given latitude.

#### multi([[acc, min, max, buckets, w, input],...])

where min and max and the minimum and maximum values of the range, buckets represents how many parts the range should be divided into, w represents the size of each bucket (number of bits in each bucket), input represents the value to be encoded and acc represents the start value of each bucket range. It returns the encoded value as a MapSet. The inputs are a set of lists.

#### Example

```elixir

    iex(1)> Sdr.multi([[0,0,100,1000,21,72],[1022,0,10,200,4,5]])
    #MapSet<[720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 1122, 1123, 1124, 1125]>

    iex(1)> Sdr.multi([[0,0,100,1000,21,73],[1022,0,10,200,4,5.1]])
    #MapSet<[730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 1123, 1124, 1125, 1126]>
```

### Merge encoder

A merge encoder merges together a set of encoded values generated from any of the other encoders. A typical input would be the temperature at a given time of day, day of week and month of year. This encoder could combine together the values encoded by a simple encoder and a set of cyclic encoders. Encoded values are successively piped into the next one to merge a chain of encodings.

#### merge(encoded1, encoded2)

where encoded1 and encoded2 are the set of encoded values as MapSets that are intened to be merged. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.simple(0, 0, 100, 100, 21, 72) |> Sdr.merge(Sdr.cyclic(122, 0, 24, 24, 8, 4))
    #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 126, 127, 128, 129, 130, 131, 132, 133]>
```