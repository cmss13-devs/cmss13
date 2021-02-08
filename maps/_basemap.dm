//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\Admin_level.dmm"
#include "map_files\generic\Low_Orbit.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\BigRed_v2\BigRed_v2.dmm"
		#include "map_files\Corsat\Corsat.dmm"
		#include "map_files\Desert_Dam\Desert_Dam.dmm"
		#include "map_files\Ice_Colony_v2\Ice_Colony_v2.dmm"
		#include "map_files\Kutjevo\Kutjevo.dmm"
		#include "map_files\LV624\LV624.dmm"
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
