
/*Access levels. Changed into defines, since that's what they should be.
It's best not to mess with the numbers of the regular access levels because
most of them are tied into map-placed objects. This should be reworked in the future.*/
//WE NEED TO REWORK THIS ONE DAY.  Access levels make me cry - Apophis
#define ACCESS_MARINE_SENIOR 1
#define ACCESS_MARINE_GENERAL 2
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
#define ACCESS_MARINE_ASO 37
#define ACCESS_MARINE_CHAPLAIN 38
#define ACCESS_MARINE_FIELD_DOC 39

/// Grants access to Marine record databases
#define ACCESS_MARINE_DATABASE 40
/// Grants administrator access to Marine record databases
#define ACCESS_MARINE_DATABASE_ADMIN 41

// AI Core Accesses
/// Used in temporary passes
#define ACCESS_MARINE_AI_TEMP 90
/// Used as dedicated access to ARES Core.
#define ACCESS_MARINE_AI 91
/// Used to access Maintenance Protocols on ARES Interface.
#define ACCESS_ARES_DEBUG 92

//=================================================

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

//CIA-locked covert items
#define ACCESS_CIA 125

//=================================================

//Weyland Yutani access levels (200-229)
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
#define ACCESS_WY_DATABASE 214
#define ACCESS_WY_LEADERSHIP 215
///Senior leadership, the highest ranks
#define ACCESS_WY_SENIOR_LEAD 216

//=================================================

//Union of Progressive Peoples access levels (230-259)
///Found on just about all Union ID cards
#define ACCESS_UPP_GENERAL 230
#define ACCESS_UPP_MEDICAL 231
#define ACCESS_UPP_ENGINEERING 232
#define ACCESS_UPP_SECURITY 233
#define ACCESS_UPP_ARMORY 234
#define ACCESS_UPP_FLIGHT 235
#define ACCESS_UPP_RESEARCH 236

#define ACCESS_UPP_COMMANDO 239
#define ACCESS_UPP_LEADERSHIP 240
///Senior leadership, the highest ranks
#define ACCESS_UPP_SENIOR_LEAD 241

//=================================================

//Colonial Liberation Front access levels (260-289)
///Found on just about all CLF ID cards
#define ACCESS_CLF_GENERAL 260
#define ACCESS_CLF_MEDICAL 261
#define ACCESS_CLF_ENGINEERING 262
#define ACCESS_CLF_SECURITY 263
#define ACCESS_CLF_ARMORY 264
#define ACCESS_CLF_FLIGHT 265

#define ACCESS_CLF_LEADERSHIP 270
///Senior leadership, the highest ranks
#define ACCESS_CLF_SENIOR_LEAD 271

//=================================================

//Three World Empire access levels (290-319)
///Found on just about all Imperial ID cards
#define ACCESS_TWE_GENERAL 290
#define ACCESS_TWE_MEDICAL 291
#define ACCESS_TWE_ENGINEERING 292
#define ACCESS_TWE_SECURITY 293
#define ACCESS_TWE_ARMORY 294
#define ACCESS_TWE_FLIGHT 295
#define ACCESS_TWE_RESEARCH 296

#define ACCESS_TWE_COMMANDO 299
#define ACCESS_TWE_LEADERSHIP 300
///Senior leadership, the highest ranks
#define ACCESS_TWE_SENIOR_LEAD 301

//=================================================

// Yautja Access Levels
/// Requires a visible ID chip to open
#define ACCESS_YAUTJA_SECURE 390
/// Elites+ only
#define ACCESS_YAUTJA_ELITE 391
/// Elders+ only
#define ACCESS_YAUTJA_ELDER 392
/// Ancients only
#define ACCESS_YAUTJA_ANCIENT 393

/// Anything in a tutorial sequence that shouldn't be accessed
#define ACCESS_TUTORIAL_LOCKED 998
///Temporary, just so I can flag places I need to change
#define ACCESS_COME_BACK_TO_ME 999


//Big lists of access codes, so I can get rid of the half a million different "get_bla_bla_bla_access" procs.
//See /proc/get_access(access_list = ACCESS_LIST_GLOBAL)
///Well... everything (non Yautja).
#define ACCESS_LIST_GLOBAL "EVERYTHING"

///Most of the USCM Access Levels used on the USS Almayer, excluding highly restricted ones.
#define ACCESS_LIST_MARINE_MAIN "Almayer (Main)"
///All USCM Access levels used on the USS Almayer
#define ACCESS_LIST_MARINE_ALL "Almayer (ALL)"
///Used by the Wey-Yu - USCM Liaison
#define ACCESS_LIST_MARINE_LIAISON "Wey-Yu (Liaison)"

///The accesses granted to emergency responders.
#define ACCESS_LIST_EMERGENCY_RESPONSE "Almayer (ERT)"
///Access used by United Americas responders.
#define ACCESS_LIST_UA "United Americas"

///Generic/basic access to Wey-Yu stuff
#define ACCESS_LIST_WY_BASE "Wey-Yu (Basic)"
///Wey-Yu Corp Security access.
#define ACCESS_LIST_WY_GOON "Wey-Yu (Goons)"
///Wey-Yu PMCs access.
#define ACCESS_LIST_WY_PMC "Wey-Yu (PMC)"
///Access levels for WY senior leadership
#define ACCESS_LIST_WY_SENIOR "Wey-Yu (Senior Lead)"
///All access levels associated with Weyland Yutani
#define ACCESS_LIST_WY_ALL "Wey-Yu (ALL)"

///All the access levels in the civillian category, excluding Press.
#define ACCESS_LIST_COLONIAL_ALL "Colonial (ALL)"
///Used by the Wey-Yu - Civil Authority Liaison
#define ACCESS_LIST_CIVIL_LIAISON "Colonial (Liaison)"
///The access used by delivery ERT (Pizza/Souto)
#define ACCESS_LIST_DELIVERY "Delivery"

///All access levels associated with UPP
#define ACCESS_LIST_UPP_ALL "UPP (ALL)"

///Generic/basic access to CLF stuff
#define ACCESS_LIST_CLF_BASE "CLF (Basic)"
///All access levels associated with CLF
#define ACCESS_LIST_CLF_ALL "CLF (ALL)"
