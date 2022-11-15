//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
//We are now moving the price of RO orders to defines, try to respect it.
#define RO_PRICE_FREE		0
#define RO_PRICE_WORTHLESS	10
#define RO_PRICE_VERY_CHEAP	20
#define RO_PRICE_CHEAP		30
#define RO_PRICE_NORMAL		40
#define RO_PRICE_NORMAL_PRICY 50//crinmbe
#define RO_PRICE_PRICY		60
#define RO_PRICE_PRICY_MID	80//god this naming schema is fucking stupid
#define RO_PRICE_VERY_PRICY	100

//new defin for price level(Will work on replace every mention of old RO PRICE little by little.)this comment will be remove before merge is request.
/*
#define ASRS_PRICE_ZERO		0///could be remove?
#define ASRS_PRICE_FREE		7/// processing back down the crate should give back what was spend at start.
#define ASRS_PRICE_TEN		10
#define ASRS_PRICE_TWENTY	20
#define ASRS_PRICE_THIRTY	30
#define ASRS_PRICE_FORTY	40
#define ASRS_PRICE_FIFTY	50
#define ASRS_PRICE_SIXTY	60
#define ASRS_PRICE_SEVENTY	70
#define ASRS_PRICE_EIGHTY	80
#define ASRS_PRICE_NINTY	90
#define ASRS_PRICE_HUNDRED	100

*/
var/list/all_supply_groups = list(
	"Operations",
	"Weapons",
	"Vehicle Modules and Ammo",
	"Attachments",
	"Ammo",
	"Weapons Specialist Ammo",
	"Armor",
	"Clothing",
	"Medical",
	"Engineering",
	"Science",
	"Supplies",
)

/datum/supply_packs
	var/name = "Basic supply pack."
	var/list/contains = list()
	var/manifest = ""
	var/cost = RO_PRICE_NORMAL
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0 //Hidden packs only show up when the computer has been hacked
	var/contraband = 0
	var/group = null
	var/buyable = 1 //Can this pack be bought? These packs don't show up at all - they have to be spawned externally (fe: DEFCON ASRS)
	var/randomised_num_contained = 0 //Randomly picks X of items out of the contains list instead of using all.
	var/iteration_needed = 0

/datum/supply_packs/New()
	if(randomised_num_contained)
		manifest += "Contains any [randomised_num_contained] of:"
	manifest += "<ul>"
	for(var/atom/movable/path in contains)
		if(!path)	continue
		manifest += "<li>[initial(path.name)]</li>"
	manifest += "</ul>"
