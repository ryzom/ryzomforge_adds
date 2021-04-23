import sys, os, csv


class TemplateParser():
	
	def __init__(self, file):
		self.filename = os.path.basename(file)
		self.path = os.path.dirname(file)+"/"
		self.parent_path = os.path.split(os.path.dirname(file))[0]+"/"
		self.elements = {}
		self.parents = []
		self.parse()

	
	def parse(self):
		buffer = [""]
		for line in open(self.path+self.filename).read().split("\n"):
			if line[:5] == "#def ":
				element_name = line[5:]
				buffer.append("")
			elif line[:5] == "#end":
				self.elements[element_name] = buffer.pop()
			else:
				buffer[-1] += line+"\n"
				
		self.elements["*"] = "\n".join(buffer)


class TemplateCSVParser():
	
	def __init__(self, template, csvname):
		self.csv = csvname
		self.template = template
		with open(template) as templatefile:
			self.template_content = templatefile.read()

	
	def apply(self, out_filename):
		headers = None
		with open(self.csv) as csvfile:
			reader = csv.reader(csvfile)
			for row in reader:
				print(row)

				if headers == None:
					headers = row
				else:
					filename = out_filename
					template = self.template_content
					print(headers)
					for i, header in enumerate(headers):
						if header:
							filename = filename.replace("%%%"+header.upper()+"%%%", row[i])
							template = template.replace("%%%"+header.upper()+"%%%", row[i])
					
					typ = row[0].split("_")[-1]
					if not os.path.isdir(os.path.dirname(filename)):
						os.makedirs(os.path.dirname(filename))
					with open(filename, "w") as outfile:
						outfile.write(template)
				
				
				
				
				
