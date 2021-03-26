//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "generic\Admin_level.dmm"
#include "generic\Low_Orbit.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "BigRed\BigRed.dmm"
		#include "CORSAT\Corsat.dmm"
		#include "DesertDam\Desert_Dam.dmm"
		#include "map_files\Ice_Colony_v2\Ice_Colony_v2.dmm"
		#include "map_files\Kutjevo\Kutjevo.dmm"
		#include "LV624\LV624.dmm"
		#include "map_files\FOP_v2_Cellblocks\Prison_Station_FOP.dmm"
		#include "map_files\FOP_v3_Sciannex\Fiorina_SciAnnex.dmm"
		#include "map_files\Sorokyne_Strata\Sorokyne_Strata.dmm"
		#include "map_files\USS_Almayer\USS_Almayer.dmm"
		#include "map_files\Whiskey_Outpost_v2\Whiskey_Outpost_v2.dmm"
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
