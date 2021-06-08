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

#### simple(min, max, buckets, w, input)

where min and max and the minimum and maximum values of the range, buckets represents how many parts the range should be divided into, w represents the size of each bucket (number of bits in each bucket) and input the value to be encoded. It returns the encoded value as a MapSet.

#### Examples

```elixir

    iex(1)> Sdr.simple(0, 100, 100, 21, 72)
    #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>

    iex(1)> Sdr.simple(0, 100, 100, 21, 73)
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

#### log(w, input)

where w represents the number of bits in each encoded output and input is the value to be encoded. It returns the encoded value as a MapSet.

#### Example

```elixir

    iex(1)> Sdr.log(21, 1)
    #MapSet<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]>

    iex(1)> Sdr.log(21, 100)
    #MapSet<[4605, 4606, 4607, 4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625]>
```