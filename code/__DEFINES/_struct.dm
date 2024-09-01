#define DEFSTRUCT(type) /datum/struct/##type;

#define DEFSTRUCTPROP(type, prop, _can_qdel) \
/datum/struct/##type/var/##prop; \
/datum/struct/##type/add_props() { \
    ..(); \
	can_qdel += _can_qdel; \
    ##prop = STRUCTS.current_struct_idx++; \
}

#define ENDDEFSTRUCT(type) \
/datum/struct/##type/proc/generate() { \
    var/list/struct = new /list(src.len); \
    struct[1] = #type; \
    return struct; \
} \
/datum/controller/structs/var/datum/struct/##type/##type; \
/datum/controller/structs/proc/generate_struct_##type() { \
    ##type = new(); \
}

#define STRUCT(type) STRUCTS.##type.generate();
#define PROP(type, prop) STRUCTS.##type.##prop

// Fun pseudo function: List.[1] works
// However SpacemanDMM throws a fit about the syntax
// #define PROP(type, prop) [STRUCTS.##type.##prop]

#define ISSTRUCT(to_test, type) (length(to_test) ? to_test[1] == #type : FALSE)

#define STRUCT_PROP_STARTING_INDEX 2
