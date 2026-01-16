//See also controllers/globals.dm

/// Creates a global initializer with a given InitValue expression, do not use
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = ##InitValue;\
	gvars_datum_init_order += #X;\
}
/// Creates an empty global initializer, do not use
#define GLOBAL_UNMANAGED(X) /datum/controller/global_vars/proc/InitGlobal##X() { return; }

/// Creates name keyed subtype instance list
#define GLOBAL_SUBTYPE_INDEXED(X, TypePath, Index)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = list();\
	for(var/t in subtypesof(TypePath)){\
		var##TypePath/A = new t;\
		var##TypePath/existing = ##X[A.##Index];\
		if(existing && !isnull(A.##Index)) stack_trace("'[A.##Index]' index for [t] in [#X] overlaps with [existing.type]! It must have a unique index for lookup!");\
		##X[A.##Index] = A;\
	}\
	gvars_datum_init_order += #X;\
}

/// Lists subtypes of a given type, indexed by initial value of a variable
#define GLOBAL_SUBTYPE_PATH_INDEXED(X, TypePath, Index)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = list();\
	for(var/t in subtypesof(TypePath)){\
		var##TypePath/A = t;\
		var##TypePath/existing = ##X[initial(A.##Index)];\
		if(existing && !isnull(initial(A.##Index))) stack_trace("'[initial(A.##Index)]' index for [t] in [#X] overlaps with [existing]! It must have a unique index for lookup!");\
		##X[initial(A.##Index)] = t;\
	}\
	gvars_datum_init_order += #X;\
}

/// Prevents a given global from being VV'd
#ifndef TESTING
#define GLOBAL_PROTECT(X)\
/datum/controller/global_vars/InitGlobal##X(){\
	CAN_BE_REDEFINED(TRUE);\
	..();\
	gvars_datum_protected_varlist[#X] = TRUE;\
}
#else
#define GLOBAL_PROTECT(X)
#endif

#define GLOBAL_SORTED(X)\
/datum/controller/global_vars/InitGlobal##X(){\
	CAN_BE_REDEFINED(TRUE);\
	..();\
	##X = sortAssoc(##X);\
}

/// Standard BYOND global, do not use
#define GLOBAL_REAL_VAR(X) var/global/##X

/// Standard typed BYOND global, do not use
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X

/// Defines a global var on the controller, do not use
#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

/// Create an untyped global with an initializer expression
#define GLOBAL_VAR_INIT(X, InitValue) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, InitValue)

/// Create a global const var, do not use
#define GLOBAL_VAR_CONST(X, InitValue) GLOBAL_RAW(/const/##X) = InitValue; GLOBAL_UNMANAGED(X)

/// Create a list global with an initializer expression
#define GLOBAL_LIST_INIT(X, InitValue) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, InitValue)

/// Create a list global that is initialized as an empty list
#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

/// Create a typed list global with an initializer expression
#define GLOBAL_LIST_INIT_TYPED(X, Typepath, InitValue) GLOBAL_RAW(/list##Typepath/X); GLOBAL_MANAGED(X, InitValue)

/// Create a typed list global that is initialized as an empty list
#define GLOBAL_LIST_EMPTY_TYPED(X, Typepath) GLOBAL_LIST_INIT_TYPED(X, Typepath, list())

/// Create a typed global with an initializer expression
#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

/// Create an untyped null global
#define GLOBAL_VAR(X) GLOBAL_RAW(/##X); GLOBAL_UNMANAGED(X)

/// Create a null global list
#define GLOBAL_LIST(X) GLOBAL_RAW(/list/##X); GLOBAL_UNMANAGED(X)

/// Create a typed null global
#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_UNMANAGED(X)

/// Load a file in as a global list
#define GLOBAL_LIST_FILE_LOAD(X, F) GLOBAL_LIST_INIT(X, file2list(F))

/// Creates datum reference list
#define GLOBAL_REFERENCE_LIST_INDEXED(X, TypePath, Index) GLOBAL_RAW(/list##TypePath/##X); GLOBAL_SUBTYPE_INDEXED(X, TypePath, Index)

#define GLOBAL_REFERENCE_LIST_INDEXED_SORTED(X, TypePath, Index) GLOBAL_RAW(/list##TypePath/##X); GLOBAL_SUBTYPE_INDEXED(X, TypePath, Index); GLOBAL_SORTED(X)

/// Creates list of subtype paths indexed by a variable
#define GLOBAL_SUBTYPE_PATHS_LIST_INDEXED(X, TypePath, Index) GLOBAL_RAW(/list/##X); GLOBAL_SUBTYPE_PATH_INDEXED(X, TypePath, Index)
