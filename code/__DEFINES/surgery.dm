///checks if the item has a path that can be specifically used in a surgery step.
#define is_surgery_tool(W) (is_type_in_typecache(W, GLOB.surgical_tools))
///checks if the item has a path that can be specifically used in a surgery step and is not flagged to not message on failed init - ex. cable coil, trauma kits etc.
#define is_surgery_init_tool(W) (is_type_in_typecache(W, GLOB.surgical_init_tools))

///Multiplier to surgery times when working on yourself.
#define SELF_SURGERY_SLOWDOWN 1.5

///No incision.
#define SURGERY_DEPTH_SURFACE "surface"
///An incision has been opened.
#define SURGERY_DEPTH_SHALLOW "shallow"
///Deep incision - opened ribcage/skull.
#define SURGERY_DEPTH_DEEP "deep"

/*Duration multipliers for patients on surfaces. Used if directly buckled to it, otherwise the shortest mult of the items on the turf is used.
Only used by complex surgeries; simple field surgeries don't care.
If you change these, remember to update the GLOB.surgery_invasiveness_levels list as well*/
///A surface that's utterly unsuitable for complex surgery. Worst possible case.
#define SURGERY_SURFACE_MULT_AWFUL 2
///A surface unsuited for surgery, but better than nothing.
#define SURGERY_SURFACE_MULT_UNSUITED 1.67
///A surface that's adequate for surgery, if not ideal.
#define SURGERY_SURFACE_MULT_ADEQUATE 1.33
///A surface that's ideal for performing surgeries.
#define SURGERY_SURFACE_MULT_IDEAL 1

/*Duration multipliers for surgical tools. As a general rule of thumb, a true surgical tool is always better than an improvised one,
unless the surgical tool is completely unsuited to what it's being used for.*/
///A tool that's badly unsuitable for the surgery. Worst usable case. Using a glass shard instead of a scalpel, using a bayonet to saw off a limb's bone.
#define SURGERY_TOOL_MULT_AWFUL 1.8
///An improvised substitute for an ill-fitting tool. Using wirecutters instead of a retractor.
#define SURGERY_TOOL_MULT_BAD_SUBSTITUTE 1.6
///A tool that's functional, but hardly good. Generally an improvised substitute for a well-matching tool - wirecutters instead of haemostat.
#define SURGERY_TOOL_MULT_SUBSTITUTE 1.4
///A tool that's a good, if not ideal, fit for the surgery -- generally a real surgical tool used slightly out of its role. Haemostat instead of retractor, fixovein instead of sutures.
#define SURGERY_TOOL_MULT_SUBOPTIMAL 1.2
///A tool that's perfect for the surgery.
#define SURGERY_TOOL_MULT_IDEAL 1

///The (no) chance of failure for surgery because the correct tools/conditions are used or skill compensates
#define SURGERY_FAILURE_IMPOSSIBLE 0
///The chance of failure for surgery because the the tool/ground is SURGERY_TOOL_MULT_BAD_SUBSTITUTE/SURGERY_SURFACE_MULT_UNSUITED and skill can't compensate enough
#define SURGERY_FAILURE_UNLIKELY 5
///The chance of failure for surgery because the the tool/ground is SURGERY_TOOL_MULT_AWFUL/SURGERY_SURFACE_MULT_AWFUL and skill can't compensate enough
#define SURGERY_FAILURE_POSSIBLE 25
///The chance of failure for surgery because the the tool and ground is some combination worse than awful and skill can't compensate enough
#define SURGERY_FAILURE_LIKELY 50

//When initiating surgeries, these define their order when listed in initiation selector or 'you can't use this tool for anything, but could x, y, or z' messages.
///Appears first in lists. Ex. larva surgery, opening incision. Immediately life-threatening or initiation surgeries.
#define SURGERY_PRIORITY_MAXIMUM 5
///Appears second in lists. Ex. IB fix, bleeding surgeries. Life-threatening or liable to get worse.
#define SURGERY_PRIORITY_HIGH 4
///Appears third in lists. Ex. bone fix, tending wounds. Worth doing but not immediately threatening. Most surgeries will be here.
#define SURGERY_PRIORITY_MODERATE 3
///Appears fourth in lists. Ex. opening ribs, amputation. Things that shouldn't be at the top of a list.
#define SURGERY_PRIORITY_LOW 2
///Appears last in lists. Ex. cauterizing incision, closing ribcage. Concluding steps.
#define SURGERY_PRIORITY_MINIMUM 1


/////////////////////////////
// SURGICAL TOOLS    //
/////////////////////////////

//Lists of tools and surgery time multipliers when using them. These are shared lists - a number of steps have their own individual lists.

///Tools routinely used to hit people, which wouldn't make sense to give 'you can't open an incision with xyz' messages.
#define SURGERY_TOOLS_NO_INIT_MSG list(\
	/obj/item/stack/medical/advanced/bruise_pack,\
	/obj/item/stack/medical/bruise_pack,\
	/obj/item/tool/kitchen/utensil/fork,\
	/obj/item/stack/cable_coil,\
	/obj/item/tool/lighter,\
	/obj/item/clothing/mask/cigarette,\
	/obj/item/tool/weldingtool,\
	/obj/item/tool/pen,\
	/obj/item/stack/rods,\
	/obj/item/tool/surgery/surgical_line,\
	/obj/item/tool/surgery/synthgraft\
	)

/////////////////////////////
// CUT AND SEAL    //
/////////////////////////////

/**Tools used to open incisions or cut flesh. IMS listed separately as the generic incision surgery uses it to skip steps.
PICT isn't as fast as standard to disincentivise using it instead of a normal scalpel.
See also /datum/surgery_step/cut_larval_pseudoroots, /datum/surgery_step/retract_skin.**/
#define SURGERY_TOOLS_INCISION list(\
	/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/scalpel/manager = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/scalpel/laser = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_SUBOPTIMAL,\
	/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/shard = SURGERY_TOOL_MULT_AWFUL\
	)

///Tools used to close incisions. May need surgical line in future. Check /datum/surgery_step/cauterize var/tools_lit if adding activatable tools.
#define SURGERY_TOOLS_CAUTERIZE list(\
	/obj/item/tool/surgery/cautery = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/wound_clamp = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/scalpel/laser = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/clothing/mask/cigarette = SURGERY_TOOL_MULT_SUBOPTIMAL,\
	/obj/item/tool/lighter = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/weldingtool = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)

/////////////////////////////
// PINCH AND PRY    //
/////////////////////////////

///Tools used to grab and remove things delicately. See also /datum/surgery_step/remove_larva.
#define SURGERY_TOOLS_PINCH list(\
	/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_AWFUL\
	)

//Generic 'SURGERY_TOOLS_PRY' is only used by /datum/surgery_step/peel_skin at present. /datum/surgery_step/retract_skin also has that list, with incision tools added.

///Tools used to pry things very finely. No crowbar, fork works decently; it can't pinch, but it's easier to maneuver precisely than wirecutters.
#define SURGERY_TOOLS_PRY_DELICATE list(\
	/obj/item/tool/surgery/retractor = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_SUBOPTIMAL,\
	/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)

/////////////////////////////
//    FLESH TEARS    //
/////////////////////////////

///Tools used to patch damaged bloodvessels. Same tools as SUTURE, but fixovein exists specifically for this work and is best at it.
#define SURGERY_TOOLS_MEND_BLOODVESSEL list(\
	/obj/item/tool/surgery/FixOVein = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/surgical_line = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,\
	/obj/item/clothing/head/headband = SURGERY_TOOL_MULT_AWFUL\
	)

///Tools used to suture damaged flesh. Same tools as BLOODVESSEL, but surgical line is ideal for this.
#define SURGERY_TOOLS_SUTURE list(\
	/obj/item/tool/surgery/surgical_line = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/FixOVein = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,\
	/obj/item/clothing/head/headband = SURGERY_TOOL_MULT_AWFUL\
	)

/////////////////////////////
// BONES SHATTER    //
/////////////////////////////

/**Tools used to sever limb bones. Same tools as /datum/surgery_step/saw_encased, but with hacking/chopping tools being better than sawing.
See also /datum/surgery_step/saw_off_limb/failure var/list/cannot_hack, listing the tools that can't instantly chop a limb.**/
#define SURGERY_TOOLS_SEVER_BONE list(\
	/obj/item/tool/surgery/circular_saw = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/weapon/twohanded/fireaxe = SURGERY_TOOL_MULT_SUBOPTIMAL,\
	/obj/item/weapon/sword/machete = SURGERY_TOOL_MULT_SUBOPTIMAL,\
	/obj/item/tool/hatchet = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/kitchen/knife/butcher = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)

///Tools used to open and close ribs/skull. Heavy-duty prying, haemostat/wirecutter won't cut it.
#define SURGERY_TOOLS_PRY_ENCASED list(\
	/obj/item/tool/surgery/retractor = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/crowbar = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)

///Tools used to patch lightly damaged bones or before setting. May need surgical line in future.
#define SURGERY_TOOLS_BONE_MEND list(\
	/obj/item/tool/surgery/bonegel = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/screwdriver = SURGERY_TOOL_MULT_SUBSTITUTE\
	)

/////////////////////////////
// Medicomp steps    //
/////////////////////////////
#define SURGERY_TOOLS_MEDICOMP_STABILIZE_WOUND list(\
	/obj/item/tool/surgery/stabilizer_gel = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/bonegel = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)

#define SURGERY_TOOLS_MEDICOMP_MEND_WOUND list(\
	/obj/item/tool/surgery/healing_gun = SURGERY_TOOL_MULT_IDEAL,\
	)

#define SURGERY_TOOLS_MEDICOMP_CLAMP_WOUND list(\
	/obj/item/tool/surgery/wound_clamp = SURGERY_TOOL_MULT_IDEAL,\
	/obj/item/tool/surgery/cautery = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/lighter = SURGERY_TOOL_MULT_SUBSTITUTE,\
	/obj/item/tool/weldingtool = SURGERY_TOOL_MULT_BAD_SUBSTITUTE\
	)
