/// A font datum, it exists to define a custom font to use in a span style later.
/datum/font
	/// Font name, just so people know what to put in their span style.
	var/name
	/// The font file we link to.
	var/font_family

/datum/font/vcr_osd_mono
	name = "VCR OSD Mono"
	font_family = 'interface/VCR_OSD_Mono.ttf'

// SS220 ADDITION - new fonts
// 6pt based
/datum/font/grand9k_pixel
	name = "Grand9K Pixel"
	font_family = 'interface/Grand9K_Pixel.ttf'

// 12pt based
/datum/font/pix_cyrillic
	name = "Pix Cyrillic"
	font_family = 'interface/Pix_Cyrillic.ttf'

// 6pt based
/datum/font/spessfont
	name = "Spess Font"
	font_family = 'interface/Spess_Font.ttf'

// 12 pt based
/datum/font/tiny_unicode
	name = "TinyUnicode"
	font_family = 'interface/TinyUnicode.ttf'

/datum/font/press_start_2p
	name = "Press Start 2P"
	font_family = 'interface/PressStart2P.ttf'
