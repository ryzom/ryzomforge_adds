import os, sys

replace = {}

with open(sys.argv[1]) as f:
	lines = f.read().split("\n")
	mode = ""
	prev_mode = ""
	for line in lines:
		sline = line.split("\t")
		if "DIFF CHANGED" in sline[0]:
			replace[sline[2]] = sline[0]+"\t"+sline[1]+"\t"


with open(sys.argv[2]) as f:
	lines = f.read().split("\n")
	final = []
	for line in lines:
		sline = line.split("\t")
		if len(sline) > 1 and sline[1] in replace:
			line = replace[sline[1]]+"\t".join(sline[1:])
			final.append(line)
	print("\n".join(final))

