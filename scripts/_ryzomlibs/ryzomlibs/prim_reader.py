import os, sys
from xml.dom.minidom import parse, parseString, Node


class PrimProp():
	
	def __init__(self, node):
		self.node = node
		self.parent = None
		self.get_infos()
	
	def get_infos(self):
		for child in self.node.childNodes:
			if child.nodeName == "NAME":
				self.name = child.childNodes[0].data
			elif child.nodeName == "STRING":
				self.value = child.childNodes[0].data

	def set_infos(self, name, value):
		for child in self.node.childNodes:
			if child.nodeName == "NAME":
				child.childNodes[0].data = name
			elif child.nodeName == "STRING":
				child.childNodes[0].data = value
				
	def set_name(self, name):
		for child in self.node.childNodes:
			if child.nodeName == "NAME":
				child.childNodes[0].data = name

	def set_value(self, value):
		for child in self.node.childNodes:
			if child.nodeName == "STRING":
				child.childNodes[0].data = value
		
class PrimChild():
	
	def __init__(self, node):
		self.node = node
		self.parent = None
		self.childs = []
		self.props = {}
		self.name = "#"
		self.classe = None
	
	def add_prop(self, prop):
		self.props[prop.name] = prop
		prop.parent = self
		if prop.name == "name":
			self.name = prop.value
		elif prop.name == "class":
			self.classe = prop.value
		
	def add_child(self, child):
		self.childs.append(child)
		child.parent = self
	
	def del_child(self, child):
		pass
		#TODO#

class PrimParser():
	
	def __init__(self, file):
		self.filename = os.path.basename(file)
		self.path = os.path.dirname(file)+"/"
		self.parent_path = os.path.split(os.path.dirname(file))[0]+"/"
		self.doc = parse(file)
	
	def parse(self):
		self.props, self.childs = self.__parse(self.doc)
		for child in self.childs:
			self.__print(child)
	
	def __print(self, childs, tabs=""):
		if childs.classe:
				print("%s%s (%s) [%s]" % (tabs, childs.name, childs.classe, ", ".join(childs.props.keys())))
		for child in childs.childs:
			if child.classe :
				print("  %s%s (%s) [%s]" % (tabs, child.name, child.classe, ", ".join(child.props.keys())))
			for child_child in child.childs:
				self.__print(child_child, tabs+"    ")
			
	def __parse(self, node):
		props = []
		childs = []
		for child in node.childNodes:
			if child.nodeName == "PROPERTY":
				new_prop = PrimProp(child)
				props.append(new_prop)
			else:
				new_child = PrimChild(child)
				child_props, child_childs = self.__parse(child)
				for child_prop in child_props:
					new_child.add_prop(child_prop)
				for child_child in child_childs:
					new_child.add_child(child_child)
				childs.append(new_child)
		return props, childs

	def save(self, file):
		xml = self.doc.toxml("utf-8")
		xml = xml.replace("<STRING/>", "<STRING></STRING>")
		xml = xml.replace("###/n###", "</STRING>\n<STRING>")
		open(file, "w").write(xml)
		
	def dumpNode(self, node):
		xml = node.toxml("utf-8")
		xml = xml.replace("<STRING/>", "<STRING></STRING>")
		xml = xml.replace("###/n###", "</STRING>\n<STRING>")
		return xml

		
	def saveNode(self, node, file):
		open(file, "w").write(dumpNode(node))


class PrimReader():
	
	def __init__(self, file):
		self.filename = os.path.basename(file)
		self.path = os.path.dirname(file)+"/"
		self.parent_path = os.path.split(os.path.dirname(file))[0]+"/"
		self.doc = parse(file)
		self.elements = {}
		self.parents = []
		self.templates = {}
		self.templates_vars = {}
		self.step_missions_templates = {}

	def save(self, file):
		xml = self.doc.toxml("utf-8")
		xml = xml.replace("<STRING/>", "<STRING></STRING>")
		xml = xml.replace("###/n###", "</STRING>\n<STRING>")
		open(file, "w").write(xml)

	def dumpNode(self, node):
		xml = node.toxml("utf-8")
		xml = xml.replace("<STRING/>", "<STRING></STRING>")
		xml = xml.replace("###/n###", "</STRING>\n<STRING>")
		return xml
		
	def saveNode(self, node, file):
		open(file, "w").write(dumpNode(node))

	def delChild(self, node):
		if node.parentNode:
			for child in node.parentNode.childNodes:
				if child.nodeType == Node.TEXT_NODE and not "<" in child.nodeValue:
					node.parentNode.removeChild(child)
			node.parentNode.removeChild(node)
	
	def delChilds(self, root_node):
		for child in root_node.childNodes:
			if child.nodeType != Node.TEXT_NODE:
				if child.tagName in ("CHILD", "PROPERTY"):
					root_node.removeChild(child)
		
	def addChild(self, node, child):
		node.appendChild(child)
	
	def addChilds(self, node, root_node):
		for child in root_node.childNodes:
			if child.nodeType != Node.TEXT_NODE:
				node.appendChild(child)

	def addChildFromString(self, node, xml):
		node.appendChild(parseString(xml).documentElement)

	def getChild(self, root, name, value):
		props =[]

		for node in root.getElementsByTagName("PROPERTY"):
			valid_node = 1
			for child in node.childNodes:
				if child.nodeName == "NAME":
					if child.childNodes[0].data != name:
						valid_node = 0
				elif child.nodeName == "STRING":
					if child.childNodes[0].data != value:
						valid_node = 0
			if valid_node:
				props.append(node.parentNode)				
		return props
	
	def getChildProps(self, root, name, value, get_all=False):
		childs = []
		props = {}
		level = 0
		if type(name) == type(""):
			names = (name, )
		else:
			names = name
		if type(value) == type(""):
			values = (value, )
		else:
			values = value

		for node in root.getElementsByTagName("PROPERTY"):
			level += 1
			valid_node = 1
			prop_name = ""
			prop_value = []
			child_for_name = ""
			child_for_value = []
			child_for_other = []
			for child in node.childNodes:
				if child.nodeName == "NAME":
					if not child.childNodes[0].data in names:
						valid_node = 0
						prop_name = child.childNodes[0].data
						child_for_name = child.childNodes[0]
				elif child.nodeName == "STRING":
					if child.childNodes and not child.childNodes[0].data in values:
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
			props[node.parentNode]["@"+prop_name] = (child_for_name, child_for_value, child_for_other)
			if valid_node or get_all:
				if not node.parentNode in childs:
					childs.append(node.parentNode)
		for node in root.getElementsByTagName("PT"):
			props[node.parentNode]["@<PT>"] = (node.getAttribute("X"),node.getAttribute("Y"))
		props["__level__"] = level
		return childs, props
	
	def setProp(self, child, props, name, value):
		if type(value[0]) != type(u"") and ord(value[0][0]) == 65279:
			value[0] = value[0][1:]
		nodes = props[child]["@"+name][1]
		if nodes:
			for node in nodes[1:]:
				self.delChild(node)
			if type(value) == type("string"):
				nodes[0].childNodes[0].data = value
			else:
				nodes[0].childNodes[0].data = "###/n###".join(value)
	
	def parseMissions(self, root_node):
		nodes, props = self.getChildProps(root_node, "", "", True)
		for node in nodes:
			if "name" in props[node]:
				name = props[node]["name"]
				if name[0] == ">": #template
					sname = name[1:].split(" ")
					if len(sname) > 1:
						template_name = sname[0]
						action_name = sname
					else:
						template_name = sname
						action_name = "#<step>#"
					self.templates[template_name] = [action_name, node]
				elif name[0] == "@":
					for var, value in self.templates_vars.items():
						name = name.replace("#"+var+"#", str(value))
					sname = name[1:].split(" ")
					if sname[0] == "include":
						if len(sname) > 2:
							for element in sname[2:]:
								selement = element.split("=")
								self.templates_vars[selement[0]] = eval(selement[1])
						template_name = sname[1]
						if template_name in self.templates:
							self.delChilds(node)
							template_new_name = self.templates[template_name][0][1]
							for var, value in self.templates_vars.items():
								template_new_name = template_new_name.replace("#"+var+"#", str(value))

							template_node = self.templates[template_name][1]
							template_code = template_node.toxml("utf-8")
							for var, value in self.templates_vars.items():
								template_code = template_code.replace("#"+var+"#", str(value))
							template_node = parseString(template_code).documentElement

							for child in self.includeMissionTemplate(template_node).childNodes:
								if child.nodeType != Node.TEXT_NODE:
									node.appendChild(child)

							#~ self.addChilds(node, self.includeMissionTemplate(self.templates[template_name][1]))
							for child_nodes in node.childNodes:
								if child_nodes.nodeName == "PROPERTY":
									for child_node in child_nodes.getElementsByTagName("NAME"):
										if child_node.childNodes[0].data == "name":
											child_node.parentNode.getElementsByTagName("STRING")[0].childNodes[0].data = template_new_name
						else:
							print("template %s not found" % template_name)
		for template_name, template_node in self.templates.values():
			self.delChild(template_node)
			
		
	def includeMissionTemplate(self, root_node):
		clone_node = root_node.cloneNode(True)
		nodes, props = self.getChildProps(clone_node, "", "", True)
		for node in nodes:
			if "name" in props[node]:
				name = props[node]["name"]
				if name[0] == "#":
					include_template = True
					for var, value in self.templates_vars.items():
						name = name.replace("#"+var+"#", str(value))
					sname = name[1:].split(" ")
					if sname[0] == "set":
						print("set", sname[1:])
						self.templates_vars[sname[1]] = eval(sname[2])
						self.delChilds(node)
					elif sname[0] == "include":
						if len(sname) > 2:
							for element in sname[2:]:
								if element[0] == "?":
									if not eval(element[1:]):
										include_template = False
								else:
									selement = element.split("=")
									self.templates_vars[selement[0]] = eval(selement[1])
						template_name = sname[1]
						if include_template: 
							if template_name in self.templates:
								self.delChilds(node)
								template_new_name = self.templates[template_name][0][1]
								for var, value in self.templates_vars.items():
									template_new_name = template_new_name.replace("#"+var+"#", str(value))
								template_node = self.templates[template_name][1]
								template_code = template_node.toxml("utf-8")
								for var, value in self.templates_vars.items():
									template_code = template_code.replace("#"+var+"#", str(value))
								template_node = parseString(template_code).documentElement
								
								for child in self.includeMissionTemplate(template_node).childNodes:
									if child.nodeType != Node.TEXT_NODE:
										node.appendChild(child)
										
								for child_nodes in node.childNodes:
									if child_nodes.nodeName == "PROPERTY":
										for child_node in child_nodes.getElementsByTagName("NAME"):
											if child_node.childNodes[0].data == "name":
												child_node.parentNode.getElementsByTagName("STRING")[0].childNodes[0].data = template_new_name
						else:
							self.delChild(node)
		return clone_node
		
	def setStepMissionTemplates(self, node, steps_list):
		nodes, props = self.getChildProps(node, "", "", True)
		for child in nodes:
			for child_nodes in child.childNodes:
				if child_nodes.nodeName == "PROPERTY":
					for child_node in child_nodes.getElementsByTagName("NAME"):
						if child_node.childNodes[0].data == "class":
							child_class = child_node.parentNode.getElementsByTagName("STRING")[0].childNodes[0].data
			if child_class in steps_list:
				self.step_templates_mission = child.cloneNode(True)
	
	def createNewMissionStep(self, mission_node, instructions):
		variables_nodes, variables_props = self.getChildProps(mission_node, "class", "variables")
		for line in instructions.split("\n"):
			if line[0] == "+":
				pass
	
	def getMissionsTree(self):
		return self.getChildProps(self.doc, "class", "mission_tree")

	def getMissions(self):
		return self.getChildProps(self.doc, "class", "mission")

	def getBaseChild(self, name, value):
		return self.getChildProps(self.doc, name, value)

