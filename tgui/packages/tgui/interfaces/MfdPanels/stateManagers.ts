import { useLocalState, useSharedState } from '../../backend';

export const useEquipmentState = (context, panelId: string) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    `${panelId}_equipmentstate`,
    undefined
  );
  return {
    equipmentState: data,
    setEquipmentState: set,
  };
};

export const fmState = (context, panelId: string) => {
  const [data, set] = useLocalState<string | undefined>(
    context,
    `${panelId}_selected_fm`,
    undefined
  );
  return {
    selectedFm: data,
    setSelectedFm: set,
  };
};

export const mfdState = (context, panelId: string) => {
  const [data, set] = useSharedState<string>(
    context,
    `${panelId}_panelstate`,
    ''
  );
  return {
    panelState: data,
    setPanelState: set,
  };
};

export const useWeaponState = (context, panelId: string) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    `${panelId}_weaponstate`,
    undefined
  );
  return {
    weaponState: data,
    setWeaponState: set,
  };
};
