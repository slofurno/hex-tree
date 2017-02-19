defmodule HextreeTest do
  use ExUnit.Case
  doctest Hextree

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "put and get element" do
    tree = Hextree.new(100)
    tree = Hextree.put(tree, 50, "HELLO")
    assert Hextree.get(tree, 50) == "HELLO"
  end

  test "insert many elements" do
    tree = Hextree.new(50000)
    t0 = :os.system_time(:milli_seconds)
    tree = Enum.reduce(0..49999, tree, &Hextree.put(&2, &1, &1))
    res = for i <- 0..49999, do: Hextree.get(tree, i)
    t1 = :os.system_time(:milli_seconds)
    IO.puts "hextree elapsed: #{t1 - t0}"
  end

  test "insert many elements into map" do
    tree = %{}
    t0 = :os.system_time(:milli_seconds)
    tree = Enum.reduce(0..49999, tree, &Map.put(&2, &1, &1))
    res = for i <- 0..49999, do: Map.get(tree, i)
    t1 = :os.system_time(:milli_seconds)
    IO.puts "map elapsed: #{t1 - t0}"
  end

  test "insert many elements into array" do
    tree = :array.new(50000)
    t0 = :os.system_time(:milli_seconds)
    tree = Enum.reduce(0..49999, tree, &:array.set(&1, &1, &2))
    res = for i <- 0..49999, do: :array.get(i, tree)
    t1 = :os.system_time(:milli_seconds)
    IO.puts "array elapsed: #{t1 - t0}"
  end

  test "created from enumerable" do
    tree = Hextree.new(1..5)
    assert Hextree.get(tree, 0) == 1
  end

  test "implements enumerable" do
    tree = Enum.reduce(1..512, Hextree.new(512), &Hextree.put(&2, &1, &1))
    assert Enum.filter(tree, & &1 <= 100) == Enum.to_list(1..100)
  end

  test "supports suspended enumeration" do
    assert Enum.zip(1..3, Hextree.new(1..3)) == [{1,1}, {2,2}, {3,3}]
  end
end
