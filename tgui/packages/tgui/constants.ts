/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

type Gas = {
  id: string;
  path: string;
  name: string;
  label: string;
  color: string;
};

// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

// All game related colors are stored here
export const COLORS = {
  // Department colors
  department: {
    captain: '#c06616',
    security: '#e74c3c',
    medbay: '#3498db',
    science: '#9b59b6',
    engineering: '#f1c40f',
    cargo: '#f39c12',
    centcom: '#00c100',
    other: '#c38312',
  },
  // Almayer colors
  shipDeps: {
    highcom: '#318779',
    command: '#004080',
    security: '#a30000',
    medsci: '#008160',
    engineering: '#a66300',
    cargo: '#5f4519',
    alpha: '#ea0000',
    bravo: '#c68610',
    charlie: '#aa55aa',
    delta: '#007fcf',
    echo: '#027d02',
    foxtrot: '#4a4740',
    raiders: '#6e1919',
  },
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
  // reagent / chemistry related colours
  reagent: {
    acidicbuffer: '#fbc314',
    basicbuffer: '#3853a4',
  },
} as const;

// Colors defined in CSS
export const CSS_COLORS = [
  'black',
  'white',
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
  'good',
  'average',
  'bad',
  'label',
  'xeno',
];

/* IF YOU CHANGE THIS KEEP IT IN SYNC WITH CHAT CSS */
export const RADIO_CHANNELS = [
  {
    name: 'Yautja',
    freq: 1205,
    color: '#1ecc43',
  },
  {
    name: 'Yautja Overseer',
    freq: 1206,
    color: '#1ecc43',
  },
  {
    name: "Dutch's Dozen",
    freq: 1210,
    color: '#1ecc43',
  },
  {
    name: 'VAI',
    freq: 1215,
    color: '#e3580e',
  },
  {
    name: 'CMB',
    freq: 1220,
    color: '#1b748c',
  },
  {
    name: 'CIA',
    freq: 1225,
    color: '#e6754c',
  },
  {
    name: 'WY',
    freq: 1231,
    color: '#fe9b24',
  },
  {
    name: 'PMC CMD',
    freq: 1232,
    color: '#4dc5ce',
  },
  {
    name: 'PMC',
    freq: 1233,
    color: '#4dc5ce',
  },
  {
    name: 'PMC ENG',
    freq: 1234,
    color: '#4dc5ce',
  },
  {
    name: 'PMC MED',
    freq: 1235,
    color: '#4dc5ce',
  },
  {
    name: 'PMC CCT',
    freq: 1236,
    color: '#4dc5ce',
  },
  {
    name: 'Deathsquad',
    freq: 1239,
    color: '#fe9b24',
  },
  {
    name: 'UPP',
    freq: 1251,
    color: '#8f4a4b',
  },
  {
    name: 'UPP CMD',
    freq: 1252,
    color: '#4a768f',
  },
  {
    name: 'UPP ENG',
    freq: 1253,
    color: '#8c5223',
  },
  {
    name: 'UPP MED',
    freq: 1254,
    color: '#159e73',
  },
  {
    name: 'UPP CCT',
    freq: 1255,
    color: '#b3222e',
  },
  {
    name: 'UPP KDO',
    freq: 1259,
    color: '#789e18',
  },
  {
    name: 'CLF',
    freq: 1271,
    color: '#8e83ca',
  },
  {
    name: 'CLF CMD',
    freq: 1272,
    color: '#4a768f',
  },
  {
    name: 'CLF ENG',
    freq: 1273,
    color: '#8c5223',
  },
  {
    name: 'CLF MED',
    freq: 1274,
    color: '#159e73',
  },
  {
    name: 'CLF CCT',
    freq: 1275,
    color: '#b3222e',
  },
  {
    name: 'LSTN BUG A',
    freq: 1290,
    color: '#d65d95',
  },
  {
    name: 'LSTN BUG B',
    freq: 1291,
    color: '#d65d95',
  },
  {
    name: 'Hyperdyne',
    freq: 1331,
    color: '#ff711a',
  },
  {
    name: 'Common',
    freq: 1461,
    color: '#1ecc43',
  },
  {
    name: 'Colony',
    freq: 1469,
    color: '#1ecc43',
  },
  {
    name: 'High Command',
    freq: 1471,
    color: '#318779',
  },
  {
    name: 'SOF',
    freq: 1472,
    color: '#318779',
  },
  {
    name: 'Provost',
    freq: 1473,
    color: '#9b0612',
  },
  {
    name: 'Sentry',
    freq: 1480,
    color: '#844300',
  },
  {
    name: 'Command',
    freq: 1481,
    color: '#779cc2',
  },
  {
    name: 'MedSci',
    freq: 1482,
    color: '#008160',
  },
  {
    name: 'Engineering',
    freq: 1483,
    color: '#a66300',
  },
  {
    name: 'MP',
    freq: 1484,
    color: '#a52929',
  },
  {
    name: 'Req',
    freq: 1485,
    color: '#ba8e41',
  },
  {
    name: 'JTAC',
    freq: 1486,
    color: '#ad3b98',
  },
  {
    name: 'Intel',
    freq: 1487,
    color: '#027d02',
  },
  {
    name: 'Alamo',
    freq: 1488,
    color: '#1ecc43',
  },
  {
    name: 'Normandy',
    freq: 1489,
    color: '#1ecc43',
  },
  {
    name: 'Alpha',
    freq: 1491,
    color: '#db2626',
  },
  {
    name: 'Bravo',
    freq: 1492,
    color: '#c68610',
  },
  {
    name: 'Charlie',
    freq: 1493,
    color: '#aa55aa',
  },
  {
    name: 'Delta',
    freq: 1494,
    color: '#007fcf',
  },
  {
    name: 'Echo',
    freq: 1495,
    color: '#3eb489',
  },
  {
    name: 'Reserves',
    freq: 1496,
    color: '#ad6d48',
  },
  {
    name: 'ARES',
    freq: 1500,
    color: '#ff00ff',
  },
] as const;

const GASES = [
  {
    id: 'o2',
    path: '/datum/gas/oxygen',
    name: 'Oxygen',
    label: 'O₂',
    color: 'blue',
  },
  {
    id: 'n2',
    path: '/datum/gas/nitrogen',
    name: 'Nitrogen',
    label: 'N₂',
    color: 'red',
  },
  {
    id: 'co2',
    path: '/datum/gas/carbon_dioxide',
    name: 'Carbon Dioxide',
    label: 'CO₂',
    color: 'grey',
  },
  {
    id: 'plasma',
    path: '/datum/gas/plasma',
    name: 'Plasma',
    label: 'Plasma',
    color: 'pink',
  },
  {
    id: 'water_vapor',
    path: '/datum/gas/water_vapor',
    name: 'Water Vapor',
    label: 'H₂O',
    color: 'lightsteelblue',
  },
  {
    id: 'nob',
    path: '/datum/gas/hypernoblium',
    name: 'Hyper-noblium',
    label: 'Hyper-nob',
    color: 'teal',
  },
  {
    id: 'n2o',
    path: '/datum/gas/nitrous_oxide',
    name: 'Nitrous Oxide',
    label: 'N₂O',
    color: 'bisque',
  },
  {
    id: 'no2',
    path: '/datum/gas/nitrium',
    name: 'Nitrium',
    label: 'Nitrium',
    color: 'brown',
  },
  {
    id: 'tritium',
    path: '/datum/gas/tritium',
    name: 'Tritium',
    label: 'Tritium',
    color: 'limegreen',
  },
  {
    id: 'bz',
    path: '/datum/gas/bz',
    name: 'BZ',
    label: 'BZ',
    color: 'mediumpurple',
  },
  {
    id: 'pluox',
    path: '/datum/gas/pluoxium',
    name: 'Pluoxium',
    label: 'Pluoxium',
    color: 'mediumslateblue',
  },
  {
    id: 'miasma',
    path: '/datum/gas/miasma',
    name: 'Miasma',
    label: 'Miasma',
    color: 'olive',
  },
  {
    id: 'Freon',
    path: '/datum/gas/freon',
    name: 'Freon',
    label: 'Freon',
    color: 'paleturquoise',
  },
  {
    id: 'hydrogen',
    path: '/datum/gas/hydrogen',
    name: 'Hydrogen',
    label: 'H₂',
    color: 'white',
  },
  {
    id: 'healium',
    path: '/datum/gas/healium',
    name: 'Healium',
    label: 'Healium',
    color: 'salmon',
  },
  {
    id: 'proto_nitrate',
    path: '/datum/gas/proto_nitrate',
    name: 'Proto Nitrate',
    label: 'Proto-Nitrate',
    color: 'greenyellow',
  },
  {
    id: 'zauker',
    path: '/datum/gas/zauker',
    name: 'Zauker',
    label: 'Zauker',
    color: 'darkgreen',
  },
  {
    id: 'halon',
    path: '/datum/gas/halon',
    name: 'Halon',
    label: 'Halon',
    color: 'purple',
  },
  {
    id: 'helium',
    path: '/datum/gas/helium',
    name: 'Helium',
    label: 'He',
    color: 'aliceblue',
  },
  {
    id: 'antinoblium',
    path: '/datum/gas/antinoblium',
    name: 'Antinoblium',
    label: 'Anti-Noblium',
    color: 'maroon',
  },
] as const;

// Returns gas label based on gasId
export const getGasLabel = (gasId: string, fallbackValue?: string) => {
  if (!gasId) return fallbackValue || 'None';

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx].label;
    }
  }

  return fallbackValue || 'None';
};

// Returns gas color based on gasId
export const getGasColor = (gasId: string) => {
  if (!gasId) return 'black';

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx].color;
    }
  }

  return 'black';
};

// Returns gas object based on gasId
export const getGasFromId = (gasId: string): Gas | undefined => {
  if (!gasId) return;

  const gasSearchString = gasId.toLowerCase();

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].id === gasSearchString) {
      return GASES[idx];
    }
  }
};

// Returns gas object based on gasPath
export const getGasFromPath = (gasPath: string): Gas | undefined => {
  if (!gasPath) return;

  for (let idx = 0; idx < GASES.length; idx++) {
    if (GASES[idx].path === gasPath) {
      return GASES[idx];
    }
  }
};
