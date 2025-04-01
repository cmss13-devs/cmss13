#define TUTORIAL_ATOM_FROM_TRACKING(path, varname) var##path/##varname = tracking_atoms[##path]
#define IS_TUTORIAL_COMPLETED(user, tutorial_id) (user.client && (tutorial_id in user.client.prefs.completed_tutorials))

#define TUTORIAL_CATEGORY_BASE "Base" // Shouldn't be used outside of base types
#define TUTORIAL_CATEGORY_SS13 "Space Station 13"
#define TUTORIAL_CATEGORY_MARINE "Marine"
#define TUTORIAL_CATEGORY_XENO "Xenomorph"
