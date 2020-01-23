#define WHITESKIN_BACKGROUND "none"
#define WHITESKIN_TEXT "#000000"

#define NIGHTSKIN_BACKGROUND "#272727"
#define NIGHTSKIN_TEXT "#b2cce5"

/client/proc/set_white_skin()
	//Mainwindow
	winset(src, "mainwindow", "background-color = [WHITESKIN_BACKGROUND]")
	winset(src, "hotkey_toggle", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "mainvsplit", "background-color = [WHITESKIN_BACKGROUND]")
	winset(src, "input", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "saybutton", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	//Outputwindow
	winset(src, "outputwindow", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "browseroutput", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "output", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	//Rpane
	winset(src, "rpane", "background-color = [WHITESKIN_BACKGROUND]")
	winset(src, "rpanewindow", "background-color = [WHITESKIN_BACKGROUND]")
	winset(src, "submitbug", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "discord", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "rulesb", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "changelog", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "forumb", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "wikib", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "textb", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "infob", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	//Infowindow
	winset(src, "infowindow", "background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT]")
	winset(src, "info", "background-color = [WHITESKIN_BACKGROUND] ; tab-background-color = [WHITESKIN_BACKGROUND] ; text-color = [WHITESKIN_TEXT] ; tab-text-color = [WHITESKIN_TEXT] ; prefix-color = [WHITESKIN_TEXT] ; suffix-color = [WHITESKIN_TEXT]")

/client/proc/set_night_skin()
	//Mainwindow
	winset(src, "mainwindow", "background-color = [NIGHTSKIN_BACKGROUND]")
	winset(src, "hotkey_toggle", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "mainvsplit", "background-color = [NIGHTSKIN_BACKGROUND]")
	winset(src, "input", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "saybutton", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	//Outputwindow
	winset(src, "outputwindow", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "browseroutput", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "output", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	//Rpane
	winset(src, "rpane", "background-color = [NIGHTSKIN_BACKGROUND]")
	winset(src, "rpanewindow", "background-color = [NIGHTSKIN_BACKGROUND]")
	winset(src, "submitbug", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "discord", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "rulesb", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "changelog", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "forumb", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "wikib", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "textb", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "infob", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	//Infowindow
	winset(src, "infowindow", "background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT]")
	winset(src, "info", "background-color = [NIGHTSKIN_BACKGROUND] ; tab-background-color = [NIGHTSKIN_BACKGROUND] ; text-color = [NIGHTSKIN_TEXT] ; tab-text-color = [NIGHTSKIN_TEXT] ; prefix-color = [NIGHTSKIN_TEXT] ; suffix-color = [NIGHTSKIN_TEXT]")