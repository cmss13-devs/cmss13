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

export const fmEditState = (context, panelId: string) => {
  const [data, set] = useLocalState<boolean>(
    context,
    `${panelId}_edit_fm`,
    false
  );
  return {
    editFm: data,
    setEditFm: set,
  };
};

export const fmWeaponEditState = (context, panelId: string) => {
  const [data, set] = useLocalState<number | undefined>(
    context,
    `${panelId}_edit_fm_weapon`,
    undefined
  );
  return {
    editFmWeapon: data,
    setEditFmWeapon: set,
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

export const useFiremissionXOffsetValue = (context) => {
  const [data, set] = useSharedState<number>(
    context,
    'firemission-x-offset-value',
    0
  );
  return {
    fmXOffsetValue: data,
    setFmXOffsetValue: set,
  };
};

export const useFiremissionYOffsetValue = (context) => {
  const [data, set] = useSharedState<number>(
    context,
    'firemission-y-offset-value',
    0
  );
  return {
    fmYOffsetValue: data,
    setFmYOffsetValue: set,
  };
};

export const useLazeTarget = (context) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    'laze-target',
    undefined
  );
  return {
    selectedTarget: data,
    setSelectedTarget: set,
  };
};
