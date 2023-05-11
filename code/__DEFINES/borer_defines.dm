/// Chemical categories
#define BORER_CAT_HEAL "Medicines"
#define BORER_CAT_PUNISH "Motivators"
#define BORER_CAT_STIM "Stimulants"
#define BORER_CAT_SELF "Self Protection"

///Amount of chemicals needed for a borer to reproduce, provided reproduction is toggled.
#define BORER_LARVAE_COST 400

#define ACTION_SET_HOSTLESS "actions_hostless"
#define ACTION_SET_HUMANOID "actions_human"
#define ACTION_SET_XENO "actions_xeno"
#define ACTION_SET_CONTROL "actions_control"

/// Borer target bitflags
#define BORER_TARGET_HUMANS (1<<0)
#define BORER_TARGET_XENOS (1<<1)
#define BORER_TARGET_YAUTJA (1<<2)

DEFINE_BITFIELD(borer_flags_targets, list(
	"TARGET_HUMANS" = BORER_TARGET_HUMANS,
	"TARGET_XENOS" = BORER_TARGET_XENOS,
	"TARGET_YAUTJA" = BORER_TARGET_YAUTJA,
))

/// Borer active/toggle-able ability flags.
/// Middle of crawling into a new host
#define BORER_PROCESS_INFESTING (1<<0)
/// Middle of taking control of a host body
#define BORER_PROCESS_BONDING (1<<1)
/// Middle of leaving a host
#define BORER_PROCESS_LEAVING (1<<2)
/// Hiding or not. (Changes layer)
#define BORER_ABILITY_HIDE (1<<3)
/// Sleeps to purify contaminant
#define BORER_ABILITY_HIBERNATING (1<<4)

DEFINE_BITFIELD(borer_flags_actives, list(
	"PROCESS_INFESTING" = BORER_PROCESS_INFESTING,
	"PROCESS_BONDING" = BORER_PROCESS_BONDING,
	"PROCESS_LEAVING" = BORER_PROCESS_LEAVING,
	"ACTIVE_HIDING" = BORER_ABILITY_HIDE,
	"ACTIVE_HIBERNATING" = BORER_ABILITY_HIBERNATING,
))

#define BORER_STATUS_CONTROLLING (1<<0)
#define BORER_STATUS_DOCILE (1<<1)

DEFINE_BITFIELD(borer_flags_status, list(
	"STATUS_CONTROLLING" = BORER_STATUS_CONTROLLING,
	"STATUS_DOCILE" = BORER_STATUS_DOCILE,
))
