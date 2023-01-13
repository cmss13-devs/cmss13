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
  dead: Observable[];
  ghosts: Observable[];
  animals: Observable[];
  misc: Observable[];
  npcs: Observable[];
  vehicles: Observable[];
  escaped: Observable[];
};

export type Observable = {
  caste?: string;
  health?: number;
  job?: string;
  full_name: string;
  nickname?: string;
  orbiters?: number;
  ref: string;
};
