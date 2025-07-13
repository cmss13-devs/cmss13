import type { BooleanLike } from 'common/react';

export type OrbitData = {
  auto_observe: BooleanLike;
  humans: Observable[];
  marines: Observable[];
  survivors: Observable[];
  xenos: Observable[];
  infected: Observable[];
  ert_members: Observable[];
  responders: Observable[];
  upp: Observable[];
  twe: Observable[];
  clf: Observable[];
  wy: Observable[];
  hyperdyne: Observable[];
  freelancer: Observable[];
  contractor: Observable[];
  mercenary: Observable[];
  dutch: Observable[];
  marshal: Observable[];
  synthetics: Observable[];
  predators: Observable[];
  hunted: Observable[];
  animals: Observable[];
  dead: Observable[];
  ghosts: Observable[];
  misc: Observable[];
  npcs: Observable[];
  vehicles: Observable[];
  escaped: Observable[];
  in_thunderdome: Observable[];
  icons?: string[];
};

export type Observable = {
  caste?: string;
  health?: number;
  icon?: string;
  job?: string;
  mutiny_status?: string;
  background_color?: string;
  background_icon?: string;
  full_name: string;
  nickname?: string;
  orbiters?: number;
  ref: string;
  hivenumber: string;
  embryo_hivenumber: string;
  area_name: string;
};

export type SquadObservable = {
  members: Array<Observable>;
  color: string;
  title: string;
};

export const buildSquadObservable: (
  title: string,
  color: string,
  members: Array<Observable>,
) => SquadObservable = (title, color, members = []) => {
  return {
    members: members,
    color: color,
    title: title,
  };
};

export type splitter = (members: Array<Observable>) => Array<SquadObservable>;
export type groupSorter = (a: Observable, b: Observable) => number;
