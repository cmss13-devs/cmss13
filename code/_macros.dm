#define to_world_log(message)    world.log << (message)

/// A message define designed to be easily found and deleted
#define debug_msg(message)   to_world(message)
#define debug_log(message)   to_world_log(message)
#define sound_to(target, sound)  target << (sound)
#define to_file(file_entry, source_var)  file_entry << (source_var)
#define from_file(file_entry, target_var)    file_entry >> (target_var)
#define close_browser(target, browser_name)  target << browse(null, "window=[browser_name]")
#define show_image(target, image)    target << (image)
#define send_rsc(target, args...) target << browse_rsc(##args)
#define open_link(target, url)   target << link(url)

#define any2ref(x) ref(x)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) CanInteract(user, GLOB.physical_state)

#define CanPhysicallyInteractWith(user, target) CanInteractWith(user, target, GLOB.physical_state)

#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null; }

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

// Helper macros to aid in optimizing lazy instantiation of lists.
// All of these are null-safe, you can use them without knowing if the list var is initialized yet

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !length(L)) L = null
// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
// Adds I to L, initializing L if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
///Returns the key of the submitted item in the list
#define LAZYFIND(L, V) (L ? L.Find(V) : 0)
// Insert I into L at position X, initializing L if necessary
#define LAZYINSERT(L, I, X) if(!L) { L = list(); } L.Insert(X, I);
// Adds I to L, initializing L if necessary, if I is not already in L
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
// Sets L[A] to I, initializing L if necessary
#define LAZYSET(L, A, I) if(!L) { L = list(); } L[A] = I;
// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
// Safely checks if I is in L
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
// Null-safe L.Cut()
#define LAZYCLEARLIST(L) L?.Cut()
// Null-safe L.Copy()
#define LAZYCOPY(L) L?.Copy()
// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
///Adds to the item K the value V, if the list is null it will initialize it
#define LAZYADDASSOC(L, K, V) if(!L) { L = list(); } L[K] += V;
///This is used to add onto lazy assoc list when the value you're adding is a /list/. This one has extra safety over lazyaddassoc because the value could be null (and thus cant be used to += objects)
#define LAZYADDASSOCLIST(L, K, V) if(!L) { L = list(); } L[K] += list(V);
///Removes the value V from the item K, if the item K is empty will remove it from the list, if the list is empty will set the list to null
#define LAZYREMOVEASSOC(L, K, V) if(L) { if(L[K]) { L[K] -= V; if(!length(L[K])) L -= K; } if(!length(L)) L = null; }
///Accesses an associative list, returns null if nothing is found
#define LAZYACCESSASSOC(L, I, K) L ? L[I] ? L[I][K] ? L[I][K] : null : null : null
///Performs an insertion on the given lazy list with the given key and value. If the value already exists, a new one will not be made.
#define LAZYORASSOCLIST(lazy_list, key, value) \
	LAZYINITLIST(lazy_list); \
	LAZYINITLIST(lazy_list[key]); \
	lazy_list[key] |= value;

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!length(list)) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

//Currently used in SDQL2 stuff
#define send_output(target, msg, control) target << output(msg, control)
#define send_link(target, url) target << link(url)

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define FLAGS_EQUALS(flag, flags) (((flag) & (flags)) == (flags))

#define IS_DIAGONAL_DIR(dir) (dir & ~(NORTH|SOUTH))

// Inverse direction, taking into account UP|DOWN if necessary.
#define REVERSE_DIR(dir) ( (((dir) & 85) << 1) | (((dir) & 170) >> 1) )

#define POSITIVE(val) max((val), 0)

#define GENERATE_DEBUG_ID "[rand(0, 9)][rand(0, 9)][rand(0, 9)][rand(0, 9)][pick(alphabet_lowercase)][pick(alphabet_lowercase)][pick(alphabet_lowercase)][pick(alphabet_lowercase)]"

#define RECT new /datum/shape/rectangle
#define SQUARE new /datum/shape/rectangle/square
#define ELLIPSE new /datum/shape/ellipse
#define CIRCLE new /datum/shape/ellipse/circle
#define QTREE new /datum/quadtree
#define SEARCH_QTREE(qtree, shape_range, flags) qtree.query_range(shape_range, null, flags)

#define HTML_FILE(contents) "<!DOCTYPE html><html><body>[contents]</body></html>"
