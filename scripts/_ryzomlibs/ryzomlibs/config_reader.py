import os
import configparser
import appdirs


class ConfigReader:

	def __init__(self):
		path = appdirs.user_data_dir("RyzomLibs", "", roaming=True)
		if not os.path.isdir(path):
			os.makedirs(path)

		self.file = path+"/prefs.cfg"
		self.config = configparser.ConfigParser()
		self.config.read(self.file)

	def get(self, section, name, ask=False):
		if section in self.config and name in self.config[section]:
			return self.config[section][name]
		elif ask:
			value = input("Please enter pref value for {} in section {}: ".format(section, name))
			self.set(section, name, value)
			self.save()
			return value
		return None
	
	def set(self, section, name, value):
		if not section in self.config:
			self.config[section] = {}
		self.config[section][name] = value
		return self
	
	def save(self):
		# Todo : manage errors
		with open(self.file, "w") as configfile:
			self.config.write(configfile)
