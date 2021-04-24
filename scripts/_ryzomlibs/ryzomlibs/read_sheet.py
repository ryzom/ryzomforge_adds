import os, sys
from xml.dom.minidom import parse, parseString


class SheetReader():
	
	def __init__(self, file):
		self.file = file
		self.filename = os.path.basename(file)
		self.path = os.path.dirname(file)+"/"
		self.parent_path = os.path.split(os.path.dirname(file))[0]+"/"
		with open(file, "r") as f:
			lines = f.read().replace("\r", "").split("\n")
		xml = ""
		for line in lines:
			xml += line.strip()
		self.doc = parseString(xml)
		self.elements = {}
		self.parents = []
	
	def get_parents(self):
		for node in self.doc.getElementsByTagName("PARENT"):
			self.parents.append(node.getAttribute("Filename"))
		return self.parents
	
	def get_structs(self):
		for node in self.doc.getElementsByTagName("STRUCT"):
			print(node)
	
	def update_with_parent(self, parent_atoms, element):
		for k, v in parent_atoms.items():
			if isinstance(v, dict):
				if not k in element:
					element[k] = v
				else:
					self.update_with_parent(v, element[k])
			else:
				element[k] = v
	
	def get_atoms(self, include_parents = True, parent_files={}):
		self.elements = {}
		if include_parents:
			self.get_parents()
			for parent in self.parents:
				if parent in parent_files:
					parent_filename = parent_files[parent]
				elif os.path.isfile(self.path+parent):
					parent_filename = self.path+parent
				elif os.path.isfile(self.path+"_parent/"+parent):
					parent_filename = self.path+"_parent/"+parent
				elif os.path.isfile(self.parent_path+"_parent/"+parent):
					parent_filename = self.parent_path+"_parent/"+parent
				else:
					print("Parent", parent, "Not Found")
					continue
				sr = SheetReader(parent_filename)
				parent_atoms = sr.get_atoms(1, parent_files)
				self.update_with_parent(parent_atoms, self.elements)
				
		for node in self.doc.getElementsByTagName("ATOM"):
			parent = node.parentNode.getAttribute("Name")
			name = node.getAttribute("Name")
			value = node.getAttribute("Value")
			if not parent in self.elements:
				self.elements[parent] = {}
			if not name:
				if not "*" in self.elements[parent]:
					self.elements[parent]["*"] = []
				self.elements[parent]["*"].append(value)
			else:
				self.elements[parent][name] = value
				
		return self.elements
	
	def updateAtom(self, name, value, struct=""):
		root = self.doc
		if struct:
			for node in self.doc.getElementsByTagName("STRUCT"):
				if node.getAttribute("Name") == struct:
					root = node
			if root == self.doc:
				print()
				node = self.doc.createElement("STRUCT")
				self.doc.getElementsByTagName("STRUCT")[0].appendChild(node)
				node.setAttribute("Name", struct)
				atom = self.doc.createElement("ATOM")
				node.appendChild(atom)
				atom.setAttribute("Name", name)
				atom.setAttribute("Value", value)
				return

		for node in root.getElementsByTagName("ATOM"):
			if node.getAttribute("Name") == name:
				node.setAttribute("Value", value)
	
	def printXml(self):
		print(self.doc.toprettyxml().replace("\t", "  "))

	def save(self):
		with open(self.file, "w") as f:
			f.write(self.doc.toprettyxml().replace("\t", "  "))

	
