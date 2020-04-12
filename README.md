# LocalStore.jl

This package provides a simple interface for storing and retrieving Julia objects locally.

Example:

```julia
using LocalStore

# Define an item descriptor
# This should contain enough information to be able to
# construct the desired object.
struct A <: LocalStore.AbstractItem
  x::Int
end

# Define how the item is stored on disk. The `path` is a dir, handled
# automatically by the LocalStore package.
LocalStore.save(a::A, path::String) = open("$path/file.txt", "w") do f
  # some difficult computation you only want to do once
  x2 = a.x^2
  # maybe download some remote files

  # now save to disk the results
  write(f, string(x2))
end

# Define how the item is read from disk.
LocalStore.load(a::A, path::String) = open("$path/file.txt", "r") do f
  parse(Int, readline(f))
end

# Automatically checks if the requested object is stored. If not,
# it creates a local directory and saves it there and loads it.
# Next time `load` is called, the stored object is returned.
a = LocalStore.load(A(5))
```
