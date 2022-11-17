//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

/* this will be remove at a later stage local define that serve no real purpose....
#define RO_PRICE_FREE		0
#define RO_PRICE_WORTHLESS	10
#define RO_PRICE_VERY_CHEAP	20
#define RO_PRICE_CHEAP		30
#define RO_PRICE_NORMAL		40
#define RO_PRICE_NORMAL_PRICY 50//crinmbe
#define RO_PRICE_PRICY		60
#define RO_PRICE_PRICY_MID	80//god this naming schema is fucking stupid
#define RO_PRICE_VERY_PRICY	100
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
	var/cost = 7 				/// Determine the price of the crate. Give it a value between 7 and 100 to avoid breaking the game.
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0 //Hidden packs only show up when the computer has been hacked
	var/contraband = 0			/// Tell if the crate is a contreband value 1 or not 0.
	var/group = null
	var/buyable = 1 			///Can this pack be bought? These packs don't show up at all - they have to be spawned externally (fe: DEFCON ASRS)
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
