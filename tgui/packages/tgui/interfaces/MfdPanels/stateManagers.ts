import { useSharedState } from 'tgui/backend';

export const useEquipmentState = (panelId: string) => {
  const [data, set] = useSharedState<number | undefined>(
    `${panelId}_equipmentstate`,
    undefined,
  );
  return {
    equipmentState: data,
    setEquipmentState: set,
  };
};

export const fmState = (panelId: string) => {
  const [data, set] = useSharedState<string | undefined>( // This was originally localState
    `${panelId}_selected_fm`,
    undefined,
  );
  return {
    selectedFm: data,
    setSelectedFm: set,
  };
};

export const fmEditState = (panelId: string) => {
  const [data, set] = useSharedState<boolean>(`${panelId}_edit_fm`, false); // This was originally localState
  return {
    editFm: data,
    setEditFm: set,
  };
};

export const fmWeaponEditState = (panelId: string) => {
  const [data, set] = useSharedState<number | undefined>( // This was originally localState
    `${panelId}_edit_fm_weapon`,
    undefined,
  );
  return {
    editFmWeapon: data,
    setEditFmWeapon: set,
  };
};

export const mfdState = (panelId: string) => {
  const [data, set] = useSharedState<string>(`${panelId}_panelstate`, '');
  return {
    panelState: data,
    setPanelState: set,
  };
};

export const otherMfdState = (otherPanelId: string | undefined) => {
  const [data] = useSharedState<string>(`${otherPanelId}_panelstate`, '');
  return {
    otherPanelState: data,
  };
};

export const useWeaponState = (panelId: string) => {
  const [data, set] = useSharedState<number | undefined>(
    `${panelId}_weaponstate`,
    undefined,
  );
  return {
    weaponState: data,
    setWeaponState: set,
  };
};

export const useFiremissionXOffsetValue = () => {
  const [data, set] = useSharedState<number>('firemission-x-offset-value', 0);
  return {
    fmXOffsetValue: data,
    setFmXOffsetValue: set,
  };
};

export const useFiremissionYOffsetValue = () => {
  const [data, set] = useSharedState<number>('firemission-y-offset-value', 0);
  return {
    fmYOffsetValue: data,
    setFmYOffsetValue: set,
  };
};

export const useLazeTarget = () => {
  const [data, set] = useSharedState<number | undefined>(
    'laze-target',
    undefined,
  );
  return {
    selectedTarget: data,
    setSelectedTarget: set,
  };
};
