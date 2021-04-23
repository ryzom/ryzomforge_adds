import os, sys


class MissionTreeParser:
	
	def __init__(self, buffer):
		self.buffer = buffer
	
	def parse(self):
		sbuffer = buffer.split("\n")
		for line in sbuffer:
			
