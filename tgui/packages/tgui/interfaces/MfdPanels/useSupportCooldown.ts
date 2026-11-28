import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';

export const useSupportCooldown = (equipment?: DropshipEquipment) => {
  const { data } = useBackend<{ worldtime: number }>();
  const [, forceUpdate] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => forceUpdate((value) => value + 1), 1000);
    return () => clearInterval(interval);
  }, []);

  const cooldownValue =
    equipment?.medevac_cooldown ??
    equipment?.system_cooldown ??
    equipment?.deployment_cooldown ??
    equipment?.spotlights_cooldown ??
    equipment?.fulton_cooldown ??
    equipment?.reload_cooldown;

  const remainingTime = Math.max(
    0,
    Math.ceil(((cooldownValue ?? 0) - data.worldtime) / 10),
  );

  return {
    isOnCooldown: remainingTime > 0,
    remainingTime,
  };
};
