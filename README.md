# Sparse Distributed Representations (SDR)

According to recent findings in neuroscience, the brain uses SDRs to process information. This is true for all mammals, from mice to humans. The SDRs visualize the information processed by the brain at a given moment, each active cell bearing some semantic aspect of the overall message.

Sparse means that only a few of the many (thousands of) neurons are active at the same time, in contrast to the typical “dense” representation, in computers, of a few bits of 0s and 1s.

Distributed means that not only are the active cells spread across the representation, but the significance of the pattern is too. This makes the SDR resilient to the failure of single neurons and allows sub-sampling.

As each bit or neuron has a meaning, if the same bit is active in two SDRs, it means that they are semantically similar: that is the key to our computational approach.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sdr` to your list of dependencies in `mix.exs`:

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

## Examples

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

## Examples

```elixir

    iex(1)> Sdr.simple(0, 100, 1, 21, 72)
    #MapSet<[72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92]>

    iex(1)> Sdr.simple(0, 100, 1, 21, 73)
    #MapSet<[73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93]>
```

### Hash encoder

A hash encoder first splits the range of values into sequential buckets of a specified size and then maps the input range over the hash of the each element in output range to generate the SDR. The advantage of this method is that you don’t need to restrict the values to an overall range while still maintaining proximity of semantically similar values.

## Example

```elixir

    iex(1)> Sdr.hash(0, 100, 1, 3, 72)
    #MapSet<["32BB90E8976AAB5298D5DA10FE66F21D", "AD61AB143223EFBC24C7D2583BE69251", "D2DDEA18F00665CE8623E36BD4E3C7C5"]>
```

### Generating documentation

```elixir
	mix docs
```