import os, sys
import cgi
from xml.dom.minidom import parse, parseString, Node

class PrimReader():
	
	def __init__(self, file):
		self.filename = os.path.basename(file)
		self.path = os.path.dirname(file)+'/'
		self.parent_path = os.path.split(os.path.dirname(file))[0]+'/'
		self.doc = parse(file)
		self.elements = {}
		self.parents = []

	def save(self, file):
		xml = self.doc.toxml('utf-8')
		xml = xml.replace("<STRING/>", "<STRING></STRING>")
		xml = xml.replace("###/n###", "</STRING>\n<STRING>")
		#for i in range(100):
		#~ xml = xml.replace("\r", "")
		#~ for i in range(100):
			#~ xml = xml.replace("\n\n", "\n")
		open(file, "w").write(xml)

	def delChild(self, node):
		for child in node.parentNode.childNodes:
			if child.nodeType == Node.TEXT_NODE and not '<' in child.nodeValue:
				node.parentNode.removeChild(child)
		node.parentNode.removeChild(node)

	def getChild(self, root, name, value):
		props =[]

		for node in root.getElementsByTagName('PROPERTY'):
			valid_node = 1
			for child in node.childNodes:
				if child.nodeName == 'NAME':
					if child.childNodes[0].data != name:
						valid_node = 0
				elif child.nodeName == 'STRING':
					if child.childNodes[0].data != value:
						valid_node = 0
			if valid_node:
				props.append(node.parentNode)
		return props
	
	def getChildProps(self, root, name, value):
		childs = []
		props = {}
		for node in root.getElementsByTagName('PROPERTY'):
			valid_node = 1
			prop_name = ""
			prop_value = []
			child_for_name = ""
			child_for_value = []
			child_for_other = []
			for child in node.childNodes:
				if child.nodeName == 'NAME':
					if child.childNodes[0].data != name:
						valid_node = 0
						prop_name = child.childNodes[0].data
						child_for_name = child.childNodes[0]
				elif child.nodeName == 'STRING':
					if child.childNodes and child.childNodes[0].data != value:
						valid_node = 0
						prop_value.append(child.childNodes[0].data)
						child_for_value.append(child)
					elif not child.childNodes:
						child_for_value.append(child)
				else:
					child_for_other.append(child)
			if not node.parentNode in props:
				props[node.parentNode] = {}
			if len(prop_value) == 1:
				props[node.parentNode][prop_name] = prop_value[0]
			else:
				props[node.parentNode][prop_name] = prop_value
			props[node.parentNode]['@'+prop_name] = (child_for_name, child_for_value, child_for_other)
			if valid_node:
				childs.append(node.parentNode)
		for node in root.getElementsByTagName('PT'):
			props[node.parentNode]['@<PT>'] = (node.getAttribute("X"),node.getAttribute("Y"))

		return childs, props
	
	def setProp(self, child, props, name, value):
		if ord(value[0][0]) == 65279:
			value[0] = value[0][1:]
		nodes = props[child]['@'+name][1]
		if nodes:
			for node in nodes[1:]:
				self.delChild(node)
			if type(value) == type("string"):
				nodes[0].childNodes[0].data = value
			else:
				nodes[0].childNodes[0].data = "###/n###".join(value)
	
	def get_missions(self):
		return self.getChildProps(self.doc, 'class', 'mission_tree')
	
	def getBaseChild(self, name, value):
		return self.getChildProps(self.doc, name, value)

