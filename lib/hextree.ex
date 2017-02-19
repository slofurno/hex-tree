defmodule Hextree do
  import Record, only: [defrecord: 2]
  use Bitwise
  defstruct [:length, :depth, :root]

  @empty_node Tuple.duplicate(:nil, 16)
  @depth_divisor :math.log10(16)

  def new(n) do
    %__MODULE__{length: n, depth: depth(n)}

  end

  def put(%__MODULE__{length: length, root: root, depth: depth} = tree, index, val) do
    path = nibble(index, depth)
    root = put_(root, val, path)
    %__MODULE__{tree| root: root}
  end

  defp put_(head, val, []) do
    val
  end

  defp put_(head, val, [x|xs]) do
    head = head || @empty_node
    next = put_(elem(head, x), val, xs)
    :erlang.setelement(x+1, head, next)
  end

  def get(%__MODULE__{length: length, depth: depth, root: root}, index) do
    path = nibble(index, depth)
    get_(root, path)
  end

  def get_(head, []), do: head

  def get_(:nil, [x|xs]), do: :nil

  def get_(head, [x|xs]) do
    get_(elem(head, x), xs)
  end

  def nibble(index, depth) do
    nibble_(depth, index, [])
  end

  def nibble_(0, _index, xs) do
    #List.foldl(xs, [], &[&1|&2])
    xs
  end

  def nibble_(depth, n, xs) do
    nibble_(depth - 1, n >>> 4,  [n &&& 15| xs])
  end

  def depth(n) do
    :math.log10(n)/@depth_divisor |> Float.ceil |> trunc
  end


end

defimpl Enumerable, for: Hextree do

  def reduce(%Hextree{length: len} = tree, {:cont, acc}, fun) do
    reduce({tree, len, 0}, {:cont, acc}, fun)
  end

  def reduce({tree, len, i}, {:cont, acc}, fun) when len === i do
    {:done, acc}
  end

  def reduce({tree, len, i}, {:cont, acc}, fun) do
     reduce({tree, len, i+1}, fun.(Hextree.get(tree, i), acc), fun)
  end

  def count(_n) do
    {:error, __MODULE__}
  end

  def member?(_n, _term) do
    {:error, __MODULE__}
  end
end
