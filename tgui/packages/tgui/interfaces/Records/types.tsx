// Generic types so far used only by SecRec and ModRec
import { BooleanLike } from 'common/react';

// all mutable stats from dm are passed in this format.
export type GenericStat = {
  record_type: string;
  stat: string;
  value: string;
  message: string;
};

// For now the general record data is immutable, keep it separate for that reason.
export type GeneralRecord = {
  value: string;
  message: string;
};

// ui is very similar for both record systems.
export type CompCommon = {
  // shared
  authenticated: BooleanLike;
  selected_target_name: string;
  id_name: string;

  // not shared but future record UI might have it too, so we will put it here.
  has_id: boolean;
  human_mob_list: string[];
};
