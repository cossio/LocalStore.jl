using Test, LocalStore

struct A
  x::Int
end

LocalStore.save(a::A, path::String) = open("$path/file.txt", "w") do f
  write(f, string(a.x^2))
end

LocalStore.load(a::A, path::String) = open("$path/file.txt", "r") do f
  parse(Int, readline(f))
end

a = LocalStore.load(A(5))
@test LocalStore.issaved(A(5))
LocalStore.clean(A(5))
@test !LocalStore.issaved(A(5))
