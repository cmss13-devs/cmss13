#define to_world_log(message)                               world.log << (message)
#define debug_msg(message)                                  to_world(message) // A message define designed to be easily found and deleted
#define debug_log(message)                                  to_world_log(message)
#define sound_to(target, sound)                             target << (sound)
#define to_file(file_entry, source_var)                     file_entry << (source_var)
#define from_file(file_entry, target_var)                   file_entry >> (target_var)
#define close_browser(target, browser_name)                 target << browse(null, "window=[browser_name]")
#define show_image(target, image)                           target << (image)
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
#define open_link(target, url)                              target << link(url)

#if DM_VERSION > 513
#warn 513 is definitely stable now, remove this
#endif
#if DM_VERSION < 513
#define any2ref(x) "\ref[x]"
#else
#define any2ref(x) ref(x)
#endif

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) CanInteract(user, GLOB.physical_state)

#define CanPhysicallyInteractWith(user, target) CanInteractWith(user, target, GLOB.physical_state)

#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null } // Second x check to handle items that LAZYREMOVE on qdel.

#define QDEL_NULL(x) if(x) { qdel(x) ; x = null }

#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE)

#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null; }

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

// Helper macros to aid in optimizing lazy instantiation of lists.
// All of these are null-safe, you can use them without knowing if the list var is initialized yet

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !L.len) L = null
// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
// Adds I to L, initalizing L if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
// Insert I into L at position X, initalizing L if necessary
#define LAZYINSERT(L, I, X) if(!L) { L = list(); } L.Insert(X, I);
// Adds I to L, initalizing L if necessary, if I is not already in L
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
// Sets L[A] to I, initalizing L if necessary
#define LAZYSET(L, A, I) if(!L) { L = list(); } L[A] = I;
// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
// Safely checks if I is in L
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
// Null-safe L.Cut()
#define LAZYCLEARLIST(L) if(L) L.Cut()
// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

//Currently used in SDQL2 stuff
#define send_output(target, msg, control) target << output(msg, control)
#define send_link(target, url) target << link(url)

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define FLAGS_EQUALS(flag, flags) ((flag & (flags)) == (flags))

#define IS_DIAGONAL_DIR(dir) (dir & ~(NORTH|SOUTH))

#define REVERSE_DIR(dir) ((dir & (NORTH|SOUTH) ? ~dir & (NORTH|SOUTH) : 0) | (dir & (EAST|WEST) ? ~dir & (EAST|WEST) : 0))

#define GENERATE_DEBUG_ID "[rand(0, 9)][rand(0, 9)][rand(0, 9)][rand(0, 9)][pick(alphabet_lowercase)][pick(alphabet_lowercase)][pick(alphabet_lowercase)][pick(alphabet_lowercase)]"

#define RECT new /datum/shape/rectangle
#define QTREE new /datum/quadtree
#define SEARCH_QTREE(qtree, shape_range, flags) qtree.query_range(shape_range, null, flags)