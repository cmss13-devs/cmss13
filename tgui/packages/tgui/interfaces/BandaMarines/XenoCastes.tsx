/* eslint-disable func-style */
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

const CASTES_RU = {
  Larva: 'Грудолом',
  'Predalien Larva': 'Грудолом чужехищника',
  Facehugger: 'Лицехват',
  'Lesser Drone': 'Трутень',
  Drone: 'Дрон',
  Runner: 'Бегун',
  Sentinel: 'Страж',
  Defender: 'Защитник',
  Burrower: 'Копатель',
  Carrier: 'Носитель',
  Hivelord: 'Владыка улья',
  Lurker: 'Охотник',
  Warrior: 'Воин',
  Spitter: 'Плевун',
  Boiler: 'Бойлер',
  Praetorian: 'Преторианец',
  Crusher: 'Крушитель',
  Ravager: 'Опустошитель',
  King: 'Король',
  Queen: 'Королева',
  Predalien: 'Чужехищник',
  Hellhound: 'Адская гончая',
  Abomination: 'Абоминация',
};

export function CastesRu(value: string) {
  return CASTES_RU[value] || value;
}

const REVERSED_CASTES_RU = Object.entries(CASTES_RU).reduce(
  (reversed_castes, [key, value]) => {
    reversed_castes[value] = key;
    return reversed_castes;
  },
  {},
);

export function ReverseCastesRu(value: string) {
  return REVERSED_CASTES_RU[value] || value;
}
