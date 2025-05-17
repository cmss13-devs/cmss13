//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define MAIN_SHIP_NAME SSmapping.get_main_ship_name()
#define MAIN_SHIP_DEFAULT_NAME "USS Almayer"
//=================================================
//Please don't edit these values without speaking to Errorage first ~Carn
//Admin Permissions
#define R_BUILDMODE (1<<0)
#define R_ADMIN (1<<1)
#define R_BAN (1<<2)
#define R_SERVER (1<<3)
#define R_DEBUG (1<<4)
#define R_POSSESS (1<<5)
#define R_PERMISSIONS (1<<6)
#define R_STEALTH (1<<7)
#define R_COLOR (1<<8)
#define R_VAREDIT (1<<9)
#define R_SOUNDS (1<<10)
#define R_SPAWN (1<<11)
#define R_MOD (1<<12)
#define R_MENTOR (1<<13)
#define R_HOST (1<<14)
#define R_PROFILER (1<<15)
#define R_NOLOCK (1<<16)
#define R_EVENT (1<<17)

/// The sum of all other rank permissions, other than host or profiler.
#define RL_EVERYTHING (R_BUILDMODE|R_ADMIN|R_BAN|R_SERVER|R_DEBUG|R_PERMISSIONS|R_POSSESS|R_STEALTH|R_COLOR|R_VAREDIT|R_EVENT|R_SOUNDS|R_NOLOCK|R_SPAWN|R_MOD|R_MENTOR)
/// Truely everything
#define RL_HOST (RL_EVERYTHING|R_HOST|R_PROFILER)

#define RL_HARMLESS (R_MENTOR|R_COLOR|R_NOLOCK)


// 512.1430 increases maximum bit flags from 16 to 24, so the following flags should be available for future changes:
//=================================================

#define CLIENT_HAS_RIGHTS(cli, flags) ((cli?.admin_holder?.rights & flags) == flags)
#define CLIENT_IS_STAFF(cli) (cli?.admin_holder?.rights & (R_MOD|R_ADMIN))
#define CLIENT_IS_MENTOR(cli) CLIENT_HAS_RIGHTS(cli, R_MENTOR)
#define CLIENT_IS_STEALTHED(cli) (CLIENT_HAS_RIGHTS(cli, R_STEALTH) && cli.prefs?.toggles_admin & ADMIN_STEALTHMODE)
#define CLIENT_IS_AFK_SAFE(cli) (CLIENT_IS_STAFF(cli) && cli.prefs?.toggles_admin & ADMIN_AFK_SAFE)

#define AHOLD_IS_MOD(ahold) (ahold && (ahold.rights & R_MOD))
#define AHOLD_IS_ADMIN(ahold) (ahold && (ahold.rights & R_ADMIN))

		//items that ask to be called every cycle
