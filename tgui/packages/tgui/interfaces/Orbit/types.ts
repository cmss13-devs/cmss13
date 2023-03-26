import { BooleanLike } from 'common/react';

export type OrbitData = {
  auto_observe: BooleanLike;
  humans: Observable[];
  marines: Observable[];
  survivors: Observable[];
  xenos: Observable[];
  ert_members: Observable[];
  synthetics: Observable[];
  predators: Observable[];
  animals: Observable[];
  dead: Observable[];
  ghosts: Observable[];
  misc: Observable[];
  npcs: Observable[];
  vehicles: Observable[];
  escaped: Observable[];
  icons?: string[];
};

export type Observable = {
  caste?: string;
  health?: number;
  icon?: string;
  job?: string;
  background_color?: string;
  full_name: string;
  nickname?: string;
  orbiters?: number;
  ref: string;
};
