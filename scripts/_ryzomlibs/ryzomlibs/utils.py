from colorama import Fore, Back, Style

def parse_print(message, end="\n"):
	colors = {
		"green" : Fore.GREEN,
		"red" : Fore.RED,
		"yellow": Fore.YELLOW,
		"blue" :  Fore.BLUE,
		"magenta":  Fore.MAGENTA,
		"cyan":  Fore.CYAN,
		"white":  Fore.WHITE,
		"black":  Fore.BLACK,
		"/": Fore.RESET+Style.RESET_ALL+Back.RESET,
		"/fore": Fore.RESET,
		"/style": Style.RESET_ALL,
		"/back": Back.RESET,
	}
	message = message.replace("[+", Style.BRIGHT+"[")
	message = message.replace("[-", Style.DIM+"[")
	for color in colors:
		message = message.replace("["+color+"]", colors[color])
	print(message+Fore.RESET+Style.RESET_ALL+Back.RESET, end=end)

def p(message, end="\n"):
	parse_print(Fore.WHITE+message, end)
	
def p_do(message, end="\n"):
	parse_print(Fore.CYAN+message, end)

def p_result(message, end="\n"):
	parse_print(Fore.GREEN+message, end)

def p_error(message, end="\n"):
	parse_print(Fore.RED+message, end)

def p_info(message, end="\n"):
	parse_print(Fore.WHITE+message, end)

def p_warning(message, end="\n"):
	parse_print(Fore.YELLOW+message, end)

def p_done():
	print(Fore.GREEN+"done!")