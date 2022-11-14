/** Radio channels */
export const CHANNELS = ['Say', 'Comms', 'Me', 'OOC'] as const;

/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 30,
  medium = 50,
  large = 70,
  width = 331,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 30,
  medium = 60,
}

/**
 * Radio prefixes.
 * Contains the properties:
 * id - string. css class identifier.
 * label - string. button label.
 */
export const RADIO_PREFIXES = {
  ':a ': {
    id: 'alpha',
    label: 'Alpha',
  },
  ':b ': {
    id: 'bravo',
    label: 'Bravo',
  },
  ':c ': {
    id: 'charlie',
    label: 'Charlie',
  },
  ':d ': {
    id: 'delta',
    label: 'Delta',
  },
  ':e ': {
    id: 'echo',
    label: 'Echo',
  },
  ':m ': {
    id: 'medsci',
    label: 'MedSci',
  },
  ':f ': {
    id: 'foxtrot',
    label: 'Foxtrot',
  },
  ':o ': {
    id: 'cct',
    label: 'CCT',
  },
  ':n ': {
    id: 'engi',
    label: 'Engi',
  },
  ':g ': {
    id: 'ship',
    label: 'Ship',
  },
  ':p ': {
    id: 'security',
    label: 'MP',
  },
  ':u ': {
    id: 'req',
    label: 'Req',
  },
  ':j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  ':t ': {
    id: 'intel',
    label: 'Int',
  },
  ':y ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':v ': {
    id: 'command',
    label: 'Comm.',
  },
  ':z ': {
    id: 'highcom',
    label: 'HC',
  },
  ':q ': {
    id: 'hive',
    label: 'Hive',
  },
  ':k ': {
    id: 'sof',
    label: 'SOF',
  },
} as const;
