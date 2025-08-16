/// From /atom/proc/Decorate
#define COMSIG_ATOM_DECORATED "atom_decorated"
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization and has a loc
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON "atom_init_success_on"
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

//from atom/set_light(): (l_range, l_power, l_color)
#define COMSIG_ATOM_SET_LIGHT "atom_set_light"

///Called right before the atom changes the value of light_range to a different one, from base atom/set_light_range(): (new_range)
#define COMSIG_ATOM_SET_LIGHT_RANGE "atom_set_light_range"
///Called right before the atom changes the value of light_power to a different one, from base atom/set_light_power(): (new_power)
#define COMSIG_ATOM_SET_LIGHT_POWER "atom_set_light_power"
///Called right before the atom changes the value of light_color to a different one, from base atom/set_light_color(): (new_color)
#define COMSIG_ATOM_SET_LIGHT_COLOR "atom_set_light_color"
///Called right before the atom changes the value of light_on to a different one, from base atom/set_light_on(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_ON "atom_set_light_on"
///Called right before the atom changes the value of light_flags to a different one, from base atom/set_light_flags(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_FLAGS "atom_set_light_flags"

///from base of atom/set_opacity(): (new_opacity)
#define COMSIG_ATOM_SET_OPACITY "atom_set_opacity"

///When the transform or an atom is varedited through vv topic.
#define COMSIG_ATOM_VV_MODIFY_TRANSFORM "atom_vv_modify_transform"

/// Called when an atom has something mouse dropped on it, from /client/MouseDrop: (atom/dropped_on)
#define COMSIG_ATOM_DROPPED_ON "atom_dropped_on"

/// Called when an atom is mouse dropped on another atom, from /client/MouseDrop: (atom/dropped_onto)
#define COMSIG_ATOM_DROP_ON "atom_drop_on"

/// Called when an atom has emp_act called on it, from /atom/emp_act: (severity)
#define COMSIG_ATOM_EMP_ACT "atom_emp_act"

///from base of atom/bullet_act(): (/obj/projectile)
#define COMSIG_ATOM_BULLET_ACT "atom_bullet_act"
