#define ATTACK_HINT_BREAK_ATTACK (1<<0)
#define ATTACK_HINT_NO_AFTERATTACK (1<<1)
#define ATTACK_HINT_NO_TELEGRAPH (1<<2)

// Note: This only works for 515.1635 at the moment, see: http://www.byond.com/forum/post/2942885
/// Use this define when a type can be attacked, the body of this define is the body of the `can_be_attacked_by` proc.
/// Can call parent on this proc (e.g. ..()) if dependent on parent calls
#define DEFINE_ATTACK_CONDITIONS_FOR(type) \
##type/can_be_attacked_by_proc_ref = type::##can_be_attacked_by(); \
##type/can_be_attacked_by()
