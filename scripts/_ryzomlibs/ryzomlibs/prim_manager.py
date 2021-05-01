import os
import sys
import json
import xml.etree.ElementTree as ET


class PrimManager():

	def __init__(self, filename):
		self.tree = ET.parse(filename)
		self.root = self.tree.getroot()
		self.elements = self.parse()

	def write(self, filename):
		self.tree.write(filename)

	def _parse_alias(self, node):
		return ("ALIAS", node.attrib)

	def _parse_property(self, node):
		if node.attrib["TYPE"] == "string":
			for child in node :
				if child.tag == "NAME":
					name = child.text
				elif child.tag == "STRING":
					value = child.text
				else:
					print("ERROR PARSING PROPERTY")
					sys.exit()
		elif node.attrib["TYPE"] == "string_array":
			value = []
			for child in node :
				if child.tag == "NAME":
					name = child.text
				elif child.tag == "STRING":
					value.append(child.text)
				else:
					print("ERROR PARSING PROPERTY")
					sys.exit()
		return (name, value)

	def _parse_child(self, node):
		elements = {}
		for child in node:
			name, value = self._parse(child)
			if name in elements:
				if not isinstance(elements[name], list):
					elements[name] = [elements[name]]
				elements[name].append(value)
			else:
				elements[name] = value
		if node.attrib["TYPE"] == "CPrimAlias":
			return ("ALIAS", elements["ALIAS"]["VALUE"])
		return (node.attrib["TYPE"], elements)

	def _parse_primitives(self, node):
		elements = {}
		for child in node:
			name, value = self._parse(child)
			elements[name] = value
		return ("PRIMITIVES", elements)

	def _parse_root_primitive(self, node):
		return self._parse_child(node)

	def _parse_pt(self, node):
		return ("PT", (node.attrib["X"], node.attrib["Y"], node.attrib["Z"]))

	def _parse(self, node):
		method = "_parse_"+node.tag.lower()
		if hasattr(self, method):
			return getattr(self, method)(node)
		#else:
		#	print("no call", method)
		return (None, None)

	def parse(self):
		name, value = self._parse(self.root)
		return {name: value}

	def toJson(self, filename):
		with open(filename, "w") as outfile:
			json.dump(self.parse(), outfile)

	def _getElementsByClass(self, classname, node):
		if not node:
			return

		if isinstance(node, list):
			for e in node:
				self._getElementsByClass(classname, e)

		elif isinstance(node, dict):
			if "class" in node and node["class"] == classname:
				self.elementsByClass.append(node)
				return

			for name, value in node.items():
				if name == "class" and value == classname:
					self.elementsByClass.append(node)
				else:
					self._getElementsByClass(classname, value)

	def _getElementsByName(self, elname, node):
		if not node:
			return

		if isinstance(node, list):
			for e in node:
				self._getElementsByName(elname, e)

		elif isinstance(node, dict):
			if "name" in node and node["name"] == elname:
				self.elementsByName.append(node)
				return

			for name, value in node.items():
				if name == "name" and value == elname:
					self.elementsByName.append(node)
				else:
					self._getElementsByName(elname, value)

	def getElementsByClass(self, classname):
		self.elementsByClass = []
		self._getElementsByClass(classname, self.elements)
		return self.elementsByClass

	def getElementsByName(self, elname):
		self.elementsByName = []
		self._getElementsByName(elname, self.elements)
		return self.elementsByName

