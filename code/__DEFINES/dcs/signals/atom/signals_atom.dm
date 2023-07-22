/// From /atom/proc/Decorate
#define COMSIG_ATOM_DECORATED "atom_decorated"

///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"

/// generally called before temporary non-parallel animate()s on the atom (animation_duration)
#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animate_start"

#define COMSIG_ATOM_DBLCLICK_SHIFT_MIDDLE "atom_dblclick_shift_middle"
#define COMSIG_ATOM_DBLCLICK_CTRL_SHIFT "atom_dblclick_ctrl_shift"
#define COMSIG_ATOM_DBLCLICK_CTRL_MIDDLE "atom_dblclick_ctrl_middle"
#define COMSIG_ATOM_DBLCLICK_MIDDLE "atom_dblclick_middle"
#define COMSIG_ATOM_DBLCLICK_SHIFT "atom_dblclick_shift"
#define COMSIG_ATOM_DBLCLICK_ALT "atom_dblclick_alt"
#define COMSIG_ATOM_DBLCLICK_CTRL "atom_dblclick_ctrl"

///called when an atom starts orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
///called when an atom stops orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"

///from /atom/hitby(): (atom/movable/AM)
#define COMSIG_ATOM_HITBY "atom_hitby"

///from /turf/ChangeTurf
#define COMSIG_ATOM_TURF_CHANGE "movable_turf_change"

///When the transform or an atom is varedited through vv topic.
#define COMSIG_ATOM_VV_MODIFY_TRANSFORM "atom_vv_modify_transform"
