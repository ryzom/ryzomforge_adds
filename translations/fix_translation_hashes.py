import os, sys

replace = {}

with open(sys.argv[1]) as f:
	lines = f.read().split("\n")
	mode = ""
	prev_mode = ""
	for line in lines:
		if "/*" in line:
			prev_mode = mode
			mode = "comment"
		elif mode == "comment":
			if "*/" in line:
				mode = prev_mode
		elif mode == "replace":
			replace[lkey] = lhash
			mode = ""
		elif mode == "hash":
			lkey = line.split(" ")[0]
			mode = "replace"
		elif mode == "warning":
			lhash = line.split(" ")[2]
			mode = "hash"
		elif "// WARNING : Hash code changed !" in line:
			mode = "warning"
		elif "// DIFF CHANGED" in line:
			mode = "warning"
		

with open(sys.argv[2]) as f:
	lines = f.read().split("\n")
	final = []
	for i in range(len(lines)):
		line = lines[i]
		if "// HASH_VALUE" in line:
			lkey = lines[i+1].split(" ")[0]
			if lkey in replace:
				line = "// HASH_VALUE "+replace[lkey]
		final.append(line)
	print("\n".join(final))
				
