
/*Access levels. Changed into defines, since that's what they should be.
It's best not to mess with the numbers of the regular access levels because
most of them are tied into map-placed objects. This should be reworked in the future.*/
//WE NEED TO REWORK THIS ONE DAY.  Access levels make me cry - Apophis
#define ACCESS_MARINE_SENIOR 1
#define ACCESS_MARINE_DATABASE 2
#define ACCESS_MARINE_BRIG 3
#define ACCESS_MARINE_ARMORY 4
#define ACCESS_MARINE_CMO 5
#define ACCESS_MARINE_CE 6
#define ACCESS_MARINE_ENGINEERING 7
#define ACCESS_MARINE_MEDBAY 8
#define ACCESS_MARINE_PREP 9
#define ACCESS_MARINE_MEDPREP 10
#define ACCESS_MARINE_ENGPREP 11
#define ACCESS_MARINE_LEADER 12
#define ACCESS_MARINE_SPECPREP 13
#define ACCESS_MARINE_SMARTPREP 14

#define ACCESS_MARINE_ALPHA 15
#define ACCESS_MARINE_BRAVO 16
#define ACCESS_MARINE_CHARLIE 17
#define ACCESS_MARINE_DELTA 18

#define ACCESS_MARINE_COMMAND 19
#define ACCESS_MARINE_CHEMISTRY 20
#define ACCESS_MARINE_CARGO 21
#define ACCESS_MARINE_DROPSHIP 22
#define ACCESS_MARINE_PILOT 23
#define ACCESS_MARINE_CMP 24
#define ACCESS_MARINE_MORGUE 25
#define ACCESS_MARINE_RO 26
#define ACCESS_MARINE_CREWMAN    27
#define ACCESS_MARINE_RESEARCH 28
#define ACCESS_MARINE_SEA    29
#define ACCESS_MARINE_KITCHEN    30
#define ACCESS_MARINE_CO 31
#define ACCESS_MARINE_TL_PREP 32

#define ACCESS_MARINE_MAINT 34
#define ACCESS_MARINE_OT 35

#define ACCESS_MARINE_SYNTH 36

// AI Core Accesses
/// Used in temporary passes
#define ACCESS_MARINE_AI_TEMP 90
/// Used as dedicated access to ARES Core.
#define ACCESS_MARINE_AI 91
/// Used to access Maintenance Protocols on ARES Interface.
#define ACCESS_ARES_DEBUG 92

//Civilian access levels
#define ACCESS_CIVILIAN_PUBLIC 100
#define ACCESS_CIVILIAN_LOGISTICS 101
#define ACCESS_CIVILIAN_ENGINEERING 102
#define ACCESS_CIVILIAN_RESEARCH 103
#define ACCESS_CIVILIAN_BRIG 104
#define ACCESS_CIVILIAN_MEDBAY 105
#define ACCESS_CIVILIAN_COMMAND 106
#define ACCESS_PRESS 110

///The generic "I'm a bad guy" access
#define ACCESS_ILLEGAL_PIRATE 120

//Weyland Yutani access levels
///Found on just about all corporate ID cards
#define ACCESS_WY_GENERAL 200
///WY employee override for most colonial areas
#define ACCESS_WY_COLONIAL 201
#define ACCESS_WY_MEDICAL 202
#define ACCESS_WY_SECURITY 203
#define ACCESS_WY_ENGINEERING 204
#define ACCESS_WY_FLIGHT 205
#define ACCESS_WY_RESEARCH 206
///WY access given to field executives, like a marine liaison.
#define ACCESS_WY_EXEC 207
#define ACCESS_WY_PMC 210
#define ACCESS_WY_PMC_TL 211
#define ACCESS_WY_ARMORY 212
///Secret research or other projects with highly restricted access
#define ACCESS_WY_SECRETS 213
#define ACCESS_WY_LEADERSHIP 215
///WY senior leadership, the highest ranks
#define ACCESS_WY_SENIOR_LEAD 216
//=================================================

// Yautja Access Levels
/// Requires a visible ID chip to open
#define ACCESS_YAUTJA_SECURE 250
/// Elders+ only
#define ACCESS_YAUTJA_ELDER 251
/// Ancients only
#define ACCESS_YAUTJA_ANCIENT 252

///Temporary, just so I can flag places I need to change
#define ACCESS_COME_BACK_TO_ME 999


//Big lists of access codes, so I can get rid of the half a million different "get_bla_bla_bla_access" procs.
//See /proc/get_access(access_list = ACCESS_LIST_GLOBAL)
///Well... everything (non Yautja).
#define ACCESS_LIST_GLOBAL "EVERYTHING"
///Most of the USCM Access Levels used on the USS Almayer, excluding highly restricted ones.
#define ACCESS_LIST_MARINE_MAIN "Marine Main"
///All USCM Access levels used on the USS Almayer
#define ACCESS_LIST_MARINE_ALL "Marine All"
///Used by the WY-USCM Liaison
#define ACCESS_LIST_WY_LIAISON "Corp Liaison"
///Weyland Yutani PMCs access.
#define ACCESS_LIST_WY_PMC "PMC"
///All access levels associated with Weyland Yutani
#define ACCESS_LIST_WY_ALL "All WY"
///All the access levels in the civillian category, excluding Press.
#define ACCESS_LIST_COLONIAL_ALL "Colonial All"
