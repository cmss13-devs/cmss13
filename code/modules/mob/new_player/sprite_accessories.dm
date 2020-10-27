/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory
	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human", "Machine", "Human Hero", "Synthetic", "Early Synthetics", "Second Generation Synthetic")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1
	var/selectable = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair
	icon = 'icons/mob/humans/human_hair.dmi'	  // default icon for all hairs

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	gender = MALE

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	gender = MALE

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"

/datum/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"

/datum/sprite_accessory/hair/longalt
	name = "Shoulder-length Hair Alt"
	icon_state = "hair_longfringe"

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"

/datum/sprite_accessory/hair/longeralt
	name = "Long Hair Alt"
	icon_state = "hair_vlongfringe"

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	selectable = 0

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"

/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	gender = FEMALE

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"
	gender = FEMALE

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	gender = MALE

/datum/sprite_accessory/hair/cleancut
	name = "Gentleman's Cut"
	icon_state = "hair_cleancut"
	gender = MALE

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	gender = MALE

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"
	selectable = 0

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"
	selectable = 0

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	selectable = 0

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	gender = FEMALE

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	gender = FEMALE

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	gender = MALE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	gender = MALE

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"
	gender = MALE

/datum/sprite_accessory/hair/combover2
	name = "Combover 2"
	icon_state = "hair_combover2"
	gender = MALE

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"
	gender = MALE

/datum/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "hair_reversemohawk"
	gender = MALE
	selectable = 0

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"
	selectable = 0

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"
	selectable = 0

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"
	selectable = 0

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"
	gender = MALE
	selectable = 0

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	gender = MALE
	selectable = 0

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"

/datum/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "hair_emolong"
	gender = FEMALE

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"
	selectable = 0

/datum/sprite_accessory/hair/fag
	name = "Flow Hair"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"
	gender = MALE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"

/datum/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "hair_jensen"
	gender = MALE

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	gender = FEMALE

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	gender = FEMALE

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"

/datum/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "hair_kagami"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	gender = FEMALE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon_state = "hair_braid"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/mbraid
	name = "Medium Braid"
	icon_state = "hair_shortbraid"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/braid2
	name = "Long Braid"
	icon_state = "hair_hbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	gender = FEMALE

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	gender = MALE // turnoff!


/datum/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "hair_thefamilyman"
	gender = MALE

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "hair_dandypompadour"
	gender = MALE

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	gender = FEMALE
	selectable = 0

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"
	gender = MALE
	selectable = 0

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"
	gender = MALE

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"
	gender = MALE

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"
	gender = MALE

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"
	gender = FEMALE

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"
	gender = FEMALE

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"
	gender = MALE

/datum/sprite_accessory/hair/flat_top_fade
	name = "Flat Top Fade"
	icon_state = "hair_mflattopfade"
	gender = MALE

/datum/sprite_accessory/hair/high_and_tight
	name = "High and Tight"
	icon_state = "hair_mhighandtight"
	gender = MALE

/datum/sprite_accessory/hair/iceman
	name = "Iceman"
	icon_state = "hair_miceman"
	gender = MALE

/datum/sprite_accessory/hair/pvt_joker
	name = "Pvt. Joker"
	icon_state = "hair_mjoker"
	gender = MALE

/datum/sprite_accessory/hair/lt_rasczak
	name = "Lt. Rasczak"
	icon_state = "hair_mrasczak"
	gender = MALE

/datum/sprite_accessory/hair/marine_fade
	name = "Marine Fade"
	icon_state = "hair_mmarinefade"
	gender = MALE

/datum/sprite_accessory/hair/marine_mohawk
	name = "Marine Mohawk"
	icon_state = "hair_mmarinemohawk"
	gender = MALE

/datum/sprite_accessory/hair/mullet
	name = "Mullet"
	icon_state = "hair_mmullet"
	gender = MALE

/datum/sprite_accessory/hair/shaved_balding
	name = "Shaved Balding"
	icon_state = "hair_mshavedbalding"
	gender = MALE

/datum/sprite_accessory/hair/wardaddy
	name = "Wardaddy"
	icon_state = "hair_mwardaddy"
	gender = MALE

/datum/sprite_accessory/hair/marine_flat_top
	name = "Marine Flat Top"
	icon_state = "hair_uflat"
	gender = MALE

/datum/sprite_accessory/hair/shaved_head
	name = "Shaved Head"
	icon_state = "hair_ushaved"
	gender = MALE

/datum/sprite_accessory/hair/head_stubble
	name = "Head Stubble"
	icon_state = "hair_ustubble"
	gender = MALE

/datum/sprite_accessory/hair/corn_rows
	name = "Corn Rows"
	icon_state = "hair_fcornrows"
	gender = FEMALE

/datum/sprite_accessory/hair/curly_hair
	name = "Curly Hair"
	icon_state = "hair_fcurly"
	gender = FEMALE

/datum/sprite_accessory/hair/pixie_cut_left
	name = "Pixie Cut Left"
	icon_state = "hair_fpixieleft"
	gender = FEMALE

/datum/sprite_accessory/hair/pixie_cut_right
	name = "Pixie Cut Right"
	icon_state = "hair_fpixieright"
	gender = FEMALE

/datum/sprite_accessory/hair/pvt_redding
	name = "Pvt. Redding"
	icon_state = "hair_fredding"
	gender = FEMALE

/datum/sprite_accessory/hair/pvt_clarison
	name = "Pvt. Clarison"
	icon_state = "hair_fbella"
	gender = FEMALE

/datum/sprite_accessory/hair/cpl_dietrich
	name = "Cpl. Dietrich"
	icon_state = "hair_fdietrich"
	gender = FEMALE

/datum/sprite_accessory/hair/pvt_vasquez
	name = "Pvt. Vasquez"
	icon_state = "hair_fvasquez"
	gender = FEMALE

/datum/sprite_accessory/hair/marine_bun
	name = "Marine Bun"
	icon_state = "hair_fbun"
	gender = FEMALE

/datum/sprite_accessory/hair/marine_bun2
	name = "Marine Bun 2"
	icon_state = "hair_fbun2"
	gender = FEMALE

/datum/sprite_accessory/hair/marine_flat_top
	name = "Marine Flat Top"
	icon_state = "hair_uflat"
	gender = FEMALE

/datum/sprite_accessory/hair/shaved_head
	name = "Shaved Head"
	icon_state = "hair_ushaved"
	gender = FEMALE

/datum/sprite_accessory/hair/head_stubble
	name = "Head Stubble"
	icon_state = "hair_ustubble"
	gender = FEMALE

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 5"
	icon_state = "hair_ponytail6"
	gender = FEMALE

/datum/sprite_accessory/hair/shorthair3
	name = "Short Hair 3"
	icon_state = "hair_shorthair3"
	selectable = 0

/datum/sprite_accessory/hair/bun
	name = "Bun"
	icon_state = "hair_bun"
	gender = FEMALE

/datum/sprite_accessory/hair/bun2
	name = "Bun 2"
	icon_state = "hair_bun2"

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"

/datum/sprite_accessory/hair/shavedbun
	name = "Shaved Bun"
	icon_state = "hair_shavedbun"
	gender = FEMALE

/datum/sprite_accessory/hair/halfshaved
	name = "Half Shaved"
	icon_state = "hair_halfshaved"
	gender = FEMALE

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"

/datum/sprite_accessory/hair/rows1
	name = "Corn Rows 2"
	icon_state = "hair_rows1"

/datum/sprite_accessory/hair/rows2
	name = "Corn Rows 3"
	icon_state = "hair_rows2"

/datum/sprite_accessory/hair/lowfade
	name = "Low Fade"
	icon_state = "hair_lowfade"

/datum/sprite_accessory/hair/medfade
	name = "Medium Fade"
	icon_state = "hair_medfade"

/datum/sprite_accessory/hair/highfade
	name = "High Fade"
	icon_state = "hair_highfade"

/datum/sprite_accessory/hair/nofade
	name = "No Fade"
	icon_state = "hair_nofade"

/datum/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"

/datum/sprite_accessory/hair/shavedpart
	name = "Partly Shaved"
	icon_state = "hair_shavedpart"

/datum/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "hair_undercut"

/datum/sprite_accessory/hair/highlight
	name = "Hightight"
	icon_state = "hair_hightight"

/datum/sprite_accessory/hair/fringetail
	name = "Fringe Tail"
	icon_state = "hair_fringetail"

/datum/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"

/datum/sprite_accessory/hair/rowdualtail
	name = "Row Tailed"
	icon_state = "hair_rowdualtail"

/datum/sprite_accessory/hair/bowlcut2
	name = "Bowl Cut 2"
	icon_state = "hair_bowlcut2"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"

/datum/sprite_accessory/hair/thinningrear
	name = "Thinning Back"
	icon_state = "hair_thinningrear"

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"

/datum/sprite_accessory/hair/averagejoe
	name = "Average Joe"
	icon_state = "hair_averagejoe"

/datum/sprite_accessory/hair/sideswept
	name = "Sideswept"
	icon_state = "hair_sideswept"

/datum/sprite_accessory/hair/mohawkshaved
	name = "Shaved Mohawk"
	icon_state = "hair_mohawkshaved"

/datum/sprite_accessory/hair/mohawkshaved2
	name = "Shaved Mohawk 2"
	icon_state = "hair_mohawkshaved2"

/datum/sprite_accessory/hair/mohawkshaved3
	name = "Shaved Mohawk 3"
	icon_state = "hair_mohawkshavednaomi"
	selectable = 0

/datum/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	icon_state = "hair_sideundercut"

/datum/sprite_accessory/hair/gentle2
	name = "Gentle 2"
	icon_state = "hair_gentle2"
	gender = FEMALE

/datum/sprite_accessory/hair/flair2
	name = "Flaired Hair 2"
	icon_state = "hair_flair2"
	gender = FEMALE

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/humans/human_facial.dmi'
	gender = MALE

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke //Technically horseshoe, but I don't want to break anyone's saves. Not like FL monday.
	name = "Horseshoe Mustache"
	icon_state = "facial_horseshoe"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"
	selectable = 0

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"
	selectable = 0

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"
	selectable = 0

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hair/threeOclock_m
	name = "3 O'clock Moustache"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hair/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hair/fiveOclock_m
	name = "5 Oclock Moustache"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hair/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hair/sevenOclock_m
	name = "7 O'clock Moustache"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hair/soul_patch
	name = "Soul Patch"
	icon_state = "facial_soulpatch"

/datum/sprite_accessory/facial_hair/full_english
	name = "Full English"
	icon_state = "facial_full_english"

/datum/sprite_accessory/facial_hair/moustachio
	name = "Moustachio"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/devilish
	name = "Devilish"
	icon_state = "facial_devilish"

/datum/sprite_accessory/facial_hair/mutton_stache
	name = "Muttonstache"
	icon_state = "facial_mutton_stache"

/datum/sprite_accessory/facial_hair/mutton_stache_7oclock
	name = "Unshaven Muttonstache"
	icon_state = "facial_mutton_stache_7oclock"

/datum/sprite_accessory/facial_hair/bulbous
	name = "Bulbous"
	icon_state = "facial_bulbous"

/datum/sprite_accessory/facial_hair/walrus
	name = "Walrus"
	icon_state = "facial_walrus"

/datum/sprite_accessory/facial_hair/super_selleck
	name = "Super Selleck"
	icon_state = "facial_super_selleck"

/datum/sprite_accessory/facial_hair/vdyke
	name = "Van Dyke"
	icon_state = "facial_vdkye"

/datum/sprite_accessory/facial_hair/vdyke_e
	name = "Van Dyke Extended"
	icon_state = "facial_vdkye_e"

/datum/sprite_accessory/facial_hair/soulful_selleck
	name = "Soulful Selleck"
	icon_state = "facial_soulful_selleck"

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/humans/species/r_human.dmi'

/datum/sprite_accessory/skin/human
	name = "Default human skin"
	icon_state = "default"

/datum/sprite_accessory/skin/human_tatt01
	name = "Tatt01 human skin"
	icon_state = "tatt1"
