using LocalStore

# Define an item type. This should contain enough information
# to be able to reconstruct the desired object.

struct A
    x::Int
end

# Since store location is based on hash, it is recommended to
# define a hash function for custom types.

Base.hash(a::A, h::UInt) = hash(:A, hash(a.x, h))

# Define how the item is stored on disk. The `path` is a dir, handled
# automatically by the LocalStore package.

LocalStore.save(a::A, path::String) = open("$path/file.txt", "w") do f
    ## some difficult computation you only want to do once
    x2 = a.x^2
    ## maybe download some remote files

    ## now save to disk the results
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
