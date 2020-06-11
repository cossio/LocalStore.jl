using Pkg

"""
	rootdir()

Root directory path where objects will be stored.
"""
rootdir() = joinpath(first(DEPOT_PATH), "store")

"""
	itemdir(obj)

Directory path where `obj` will be stored.
"""
itemdir(obj) = joinpath(rootdir(), string(hash(obj), base=16))

"""
	issaved(obj)

Returns true if `obj` is locally stored, false otherwise.
"""
issaved(obj) = isdir(itemdir(obj))

"""
	save(obj)

Stores `obj` locally if it has not been stored already.
Returns path to directory containing `obj`.
"""
function save(obj)
	if !issaved(obj)
		@info "Storing $obj into $(itemdir(obj))"
		mkpath(itemdir(obj))
		save(obj, itemdir(obj))
		#verify(obj)
	end
	return itemdir(obj)
end

"""
	load(obj)

Reads and returns the specified object. Stores it locally if it hasn't been
stored already.
"""
function load(obj)
	issaved(obj) || save(obj)
	load(obj, itemdir(obj))
end

"""
	verify(obj)

Compares the tree_hash of the stored copy of `obj` to the expected tree_hash,
and errors if there is a difference.
"""
function verify(obj)
	issaved(obj) || error("$obj not stored.")
	if Pkg.GitTools.tree_hash(itemdir(obj)) ≠ expected_tree_hash(obj)
		error("Corrupted store for $obj.")
	end
end

"""
	expected_tree_hash(obj)

Expected tree hash for the saved contents of `obj`. Overload this for specific
item types. Otherwise simply returns the hash of the contents of the store
(so no verification happens).
"""
function expected_tree_hash(obj)
	issaved(obj) || error("$obj not stored.")
	Pkg.GitTools.tree_hash(itemdir(obj))
end

"""
	clean(; force=false)

Removes all stored data directories.
"""
function clean(; force::Bool=false)
	if force
		rm(rootdir(), recursive=true, force=true)
	else
		print("Clean store. Type 'yes' to confirm: ")
		if readline() == "yes"
			clean(; force=true)
		end
	end
end

"""
	clean(obj)

Removes the stored data associated with `obj`.
"""
clean(obj) = issaved(obj) && rm(itemdir(obj), recursive=true)
