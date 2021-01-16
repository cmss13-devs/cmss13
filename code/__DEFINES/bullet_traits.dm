// The way bullet traits are added to projectiles, you pass an assoc list
// where they key is the trait typepath or an id string and the value is a
// list of args if there are any args
/// An entry to a list for giving projectiles bullet traits
/// Must be placed inside of a list
#define BULLET_TRAIT_ENTRY(trait, args...) trait = #args ? list(##args) : null
/// An entry to a list for giving projectiles bullet traits with a unique ID
/// Must be placed inside of a list
#define BULLET_TRAIT_ENTRY_ID(id, trait, args...) id = list(trait, ##args)

// Helper defines for less ugly syntax (just need to put in a bullet trait entry)
#define add_bullet_trait(entry) add_bullet_traits(list(##entry))
#define remove_bullet_trait(entry) remove_bullet_traits(list(##entry))

/// Helper define for directly changing a projectile's bullet traits
#define GIVE_BULLET_TRAIT(projectile, trait, args...) projectile._AddElement(list(trait, ##args))
