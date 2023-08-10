/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

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
};

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
    freq: 1214,
    color: '#1ecc43',
  },
  {
    name: 'PMC',
    freq: 1235,
    color: '#1ecc43',
  },
  {
    name: 'WY',
    freq: 1236,
    color: '#1ecc43',
  },
  {
    name: "Dutch's Dozen",
    freq: 1340,
    color: '#1ecc43',
  },
  {
    name: 'VAI',
    freq: 1218,
    color: '#1ecc43',
  },
  {
    name: 'ERT',
    freq: 1342,
    color: '#1ecc43',
  },
  {
    name: 'UPP',
    freq: 1338,
    color: '#1ecc43',
  },
  {
    name: 'CLF',
    freq: 1339,
    color: '#1ecc43',
  },
  {
    name: 'Deathsquad',
    freq: 1344,
    color: '#1ecc43',
  },
  {
    name: 'ARES',
    freq: 1447,
    color: '#1ecc43',
  },
  {
    name: 'High Command',
    freq: 1240,
    color: '#1ecc43',
  },
  {
    name: 'CCT',
    freq: 1350,
    color: '#1ecc43',
  },
  {
    name: 'Command',
    freq: 1353,
    color: '#1ecc43',
  },
  {
    name: 'Medsci',
    freq: 1355,
    color: '#1ecc43',
  },
  {
    name: 'Engineering',
    freq: 1357,
    color: '#1ecc43',
  },
  {
    name: 'MP',
    freq: 1359,
    color: '#1ecc43',
  },
  {
    name: 'Req',
    freq: 1354,
    color: '#1ecc43',
  },
  {
    name: 'JTAC',
    freq: 1358,
    color: '#1ecc43',
  },
  {
    name: 'Intel',
    freq: 1356,
    color: '#1ecc43',
  },
  {
    name: 'Alamo',
    freq: 1441,
    color: '#1ecc43',
  },
  {
    name: 'Normandy',
    freq: 1443,
    color: '#1ecc43',
  },
  {
    name: 'Alpha',
    freq: 1449,
    color: '#1ecc43',
  },
  {
    name: 'Bravo',
    freq: 1451,
    color: '#1ecc43',
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
    name: 'MARSOC',
    freq: 1241,
    color: '#1ecc43',
  },
  {
    name: 'Reserves',
    freq: 1457,
    color: '#1ecc43',
  },
  {
    name: 'Echo',
    freq: 1456,
    color: '#1ecc43',
  },
  {
    name: 'Delta',
    freq: 1455,
    color: '#1ecc43',
  },
  {
    name: 'Charlie',
    freq: 1453,
    color: '#1ecc43',
  },
];

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
];

export const getGasLabel = (gasId, fallbackValue) => {
  const gasSearchString = String(gasId).toLowerCase();
  // prettier-ignore
  const gas = GASES.find((gas) => (
    gas.id === gasSearchString
      || gas.name.toLowerCase() === gasSearchString
  ));
  return (gas && gas.label) || fallbackValue || gasId;
};

export const getGasColor = (gasId) => {
  const gasSearchString = String(gasId).toLowerCase();
  // prettier-ignore
  const gas = GASES.find((gas) => (
    gas.id === gasSearchString
      || gas.name.toLowerCase() === gasSearchString
  ));
  return gas && gas.color;
};

export const getGasFromId = (gasId) => {
  const gasSearchString = String(gasId).toLowerCase();
  // prettier-ignore
  const gas = GASES.find((gas) => (
    gas.id === gasSearchString
      || gas.name.toLowerCase() === gasSearchString
  ));
  return gas;
};

// Paths need to be exact matches so we dont need to lowercase stuffs.
export const getGasFromPath = (gasPath) => {
  return GASES.find((gas) => gasPath === gas.path);
};
