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

## Examples

```elixir

	iex(1)> Sdr.capacity(2048, 6)
	101733385755251712

	iex(1)> Sdr.sparsity(2048, 6)
	0.0029296875

	iex(1)> Sdr.overlap(MapSet.new([1, 2]), MapSet.new([2, 3]))
	#MapSet<[2]>
```
### Generating documentation

```elixir
	mix docs
```