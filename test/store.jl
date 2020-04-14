using Test, LocalStore

struct A
    x::Int
end

Base.hash(a::A, h::UInt) = hash(A.name, hash(a.x, h))

LocalStore.save(a::A, path::String) = open("$path/file.txt", "w") do f
    write(f, string(a.x^2))
end

LocalStore.load(a::A, path::String) = open("$path/file.txt", "r") do f
    parse(Int, readline(f))
end

a = LocalStore.load(A(5))
@test LocalStore.issaved(A(5))
@test a == 25
@test LocalStore.load(A(5)) == 25

LocalStore.clean(A(5))
@test !LocalStore.issaved(A(5))
