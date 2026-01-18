import type { BooleanLike } from 'common/react';
import { useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  Modal,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

const sanitizeText = (text: string) => {
  if (!text) return '';
  // Remove control characters, emojis, and other problematic characters
  return text.replace(/[^\x20-\x7E]/g, '');
};

type PillBottleType = {
  size: number;
  max_size: number;
  label?: string;
  icon_state: string;
  isNeedsToBeFilled: BooleanLike;
};

type ChemMasterData = {
  is_connected: BooleanLike;
  pill_bottles: PillBottleType[];
  color_pill: {
    icon: string;
    colors: { [key: string]: string };
    base: string;
  };
  beaker?: {
    reagents_volume: number;
    reagents: Reagent[];
  };
  buffer?: Reagent[];
  mode: BooleanLike;
  pill_or_bottle_icon: string;
  pill_icon_choices: number;
  bottle_icon_choices: number;
  bottlesprite: number;
  pillsprite: number;
  is_pillmaker: BooleanLike;
  is_condiment: BooleanLike;
  is_vialmaker: BooleanLike;
  internal_reagent_name: string;
  presets: {
    [key: string]: {
      bottle_color?: string;
      bottle_label?: string;
      pill_color?: number;
      order: number;
      quick_access_slot?: number;
      quick_access_label?: string;
      stored_quick_access_label?: string;
      use_preset_name_as_label?: BooleanLike;
    };
  };
};

type Reagent = {
  name: string;
  volume: number;
  id: number;
};

export const ChemMaster = () => {
  const { act, data } = useBackend<ChemMasterData>();

  const { is_connected, beaker, buffer, mode } = data;

  const [glasswarePicker, setGlasswarePicker] = useState<
    'pill' | 'bottle' | false
  >(false);
  const [pillPicker, setPillPicker] = useState(false);
  const [selectedPillBottleColor, setSelectedPillBottleColor] = useState<
    string | null
  >(null);
  const [pillBottleLabel, setPillBottleLabel] = useState('');
  const [selectedPillColor, setSelectedPillColor] = useState<number | null>(
    null,
  );
  const [pillBottleColorPicker, setPillBottleColorPicker] = useState(false);
  const [pillColorPicker, setPillColorPicker] = useState(false);

  // Preset management state
  const [showPresets, setShowPresets] = useState(false);
  const [creatingPreset, setCreatingPreset] = useState(false);
  const [editingPreset, setEditingPreset] = useState<string | null>(null);
  const [deletingPreset, setDeletingPreset] = useState<string | null>(null);
  const [showReorderButtons, setShowReorderButtons] = useState(false);
  const [showQuickAccessOptions, setShowQuickAccessOptions] = useState<
    string | null
  >(null);
  const [presetName, setPresetName] = useState('');
  const [showOverwriteWarning, setShowOverwriteWarning] = useState(false);
  const [showQuickAccess, setShowQuickAccess] = useSharedState(
    'showQuickAccess',
    true,
  );
  const [usePresetNameAsLabel, setUsePresetNameAsLabel] = useState(false);

  // Helper functions for UI elements
  const getBackgroundColor = (colorName: string | undefined) => {
    if (!colorName) return undefined;

    // Map color names to CSS colors
    const colorMap = {
      Orange: 'rgba(255, 165, 0, 0.5)',
      Blue: 'rgba(0, 0, 255, 0.5)',
      Yellow: 'rgba(255, 255, 0, 0.5)',
      'Light Purple': 'rgba(177, 156, 217, 0.5)',
      'Light Grey': 'rgba(200, 200, 200, 0.5)',
      White: 'rgba(255, 255, 255, 0.5)',
      'Light Green': 'rgba(144, 238, 144, 0.5)',
      Cyan: 'rgba(0, 255, 255, 0.5)',
      Bordeaux: 'rgba(128, 0, 32, 0.5)',
      Aquamarine: 'rgba(127, 255, 212, 0.5)',
      Grey: 'rgba(128, 128, 128, 0.5)',
      Red: 'rgba(255, 0, 0, 0.5)',
      Black: 'rgba(36, 16, 0, 0.5)',
    };

    return colorMap[colorName] || 'rgba(200, 200, 200, 0.5)'; // Default to light grey if color not found
  };

  // Reset form when not editing or creating
  useEffect(() => {
    if (editingPreset && data.presets && data.presets[editingPreset]) {
      const preset = data.presets[editingPreset];
      setPresetName(editingPreset);
      // Only set these values once when the editing preset changes
      setSelectedPillBottleColor(preset.bottle_color || null);
      setPillBottleLabel(preset.bottle_label || '');
      setSelectedPillColor(preset.pill_color || null);
      setUsePresetNameAsLabel(!!preset.use_preset_name_as_label);
    } else if (!editingPreset && !creatingPreset) {
      setPresetName('');
      setSelectedPillBottleColor(null);
      setPillBottleLabel('');
      setSelectedPillColor(null);
      setUsePresetNameAsLabel(false);
    }
  }, [editingPreset]);

  // Reset overwrite warning when preset name changes
  useEffect(() => {
    setShowOverwriteWarning(false);
  }, [presetName]);

  // Preset management handlers
  const handlePresetReorder =
    (presetName: string, direction: 'up' | 'down') => (e: React.MouseEvent) => {
      e.stopPropagation();
      act('reorder_preset', { name: presetName, direction });
    };

  const handlePresetEdit = (presetName: string) => (e: React.MouseEvent) => {
    e.stopPropagation();
    setEditingPreset(presetName);
    setCreatingPreset(true);
    setShowPresets(false);
  };

  const handlePresetDelete = (presetName: string) => (e: React.MouseEvent) => {
    e.stopPropagation();
    if (deletingPreset === presetName) {
      act('delete_preset', { name: presetName });
      setDeletingPreset(null);
    } else {
      setDeletingPreset(presetName);
    }
  };

  const handlePresetApply = (presetName: string) => () => {
    act('apply_preset', { name: presetName });
    setShowPresets(false);
  };

  const savePreset = () => {
    if (editingPreset !== presetName && data.presets[presetName]) {
      if (showOverwriteWarning) {
        submitSave();
        setShowOverwriteWarning(false);
      } else {
        setShowOverwriteWarning(true);
      }
    } else {
      submitSave();
    }
  };

  const submitSave = () => {
    // Sanitize inputs
    const sanitizedPresetName = sanitizeText(presetName || editingPreset || '');
    const sanitizedBottleLabel = sanitizeText(pillBottleLabel || '').substring(
      0,
      3,
    );

    const saveData: any = {
      name: sanitizedPresetName,
      original_name: editingPreset,
      bottle_color: selectedPillBottleColor,
      bottle_label: sanitizedBottleLabel,
      pill_color: selectedPillColor,
      use_preset_name_as_label: usePresetNameAsLabel ? 1 : 0,
    };

    // If we're editing an existing preset with quick access settings, preserve them
    if (editingPreset && data.presets[editingPreset]) {
      // Preserve quick access settings if they exist
      if (data.presets[editingPreset].quick_access_slot !== undefined) {
        saveData.quick_access_slot =
          data.presets[editingPreset].quick_access_slot;
        saveData.quick_access_label = sanitizeText(
          data.presets[editingPreset].quick_access_label || '',
        ).substring(0, 3);
      }

      // Also preserve stored label for when quick access is re-added later
      if (data.presets[editingPreset].stored_quick_access_label) {
        saveData.stored_quick_access_label = sanitizeText(
          data.presets[editingPreset].stored_quick_access_label,
        ).substring(0, 3);
      }
    }

    // By default, set quick access label to match pill bottle label if it exists
    if (
      saveData.quick_access_slot !== undefined &&
      !saveData.quick_access_label &&
      saveData.bottle_label
    ) {
      saveData.quick_access_label = saveData.bottle_label;
    }

    act('save_preset', saveData);
    setCreatingPreset(false);
    setEditingPreset(null);
    setShowPresets(true);
  };

  return (
    <Window width={550} height={600}>
      <Window.Content
        className="ChemMaster"
        onClick={() => setDeletingPreset(null)}
      >
        <Section fill scrollable>
          <Section
            title={
              <Stack fill align="center">
                <Stack.Item>Status</Stack.Item>
                <Stack.Item ml="auto">
                  <Stack>
                    {data.pill_bottles.length > 1 && (
                      <Stack.Item>
                        <Button
                          icon="check-double"
                          tooltip={
                            data.pill_bottles.length ===
                            data.pill_bottles.filter(
                              (bottle) => bottle.isNeedsToBeFilled,
                            ).length
                              ? 'Deselect all pill bottles'
                              : 'Select all pill bottles'
                          }
                          onClick={() => {
                            act('select_all_bottles', {
                              value:
                                data.pill_bottles.length !==
                                data.pill_bottles.filter(
                                  (bottle) => bottle.isNeedsToBeFilled,
                                ).length,
                            });
                          }}
                        >
                          {data.pill_bottles.length ===
                          data.pill_bottles.filter(
                            (bottle) => bottle.isNeedsToBeFilled,
                          ).length
                            ? 'Deselect All'
                            : 'Select All'}
                        </Button>
                      </Stack.Item>
                    )}
                    <Stack.Item ml={data.pill_bottles.length > 1 ? 1 : 0}>
                      <Button
                        icon="save"
                        tooltip="Manage and apply presets"
                        onClick={() => setShowPresets(true)}
                      >
                        Presets
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            }
          >
            {data.presets &&
              showQuickAccess &&
              Object.entries(data.presets).filter(
                ([_name, preset]) => preset.quick_access_slot !== undefined,
              ).length > 0 && (
                <Box mb={1}>
                  <Stack>
                    <Stack.Item grow>
                      <Stack wrap="true">
                        {Object.entries(data.presets)
                          .filter(
                            ([_name, preset]) =>
                              preset.quick_access_slot !== undefined,
                          )
                          .sort(
                            ([_nameA, a], [_nameB, b]) =>
                              (a.quick_access_slot || 0) -
                              (b.quick_access_slot || 0),
                          )
                          .map(([presetName, preset]) => (
                            <Stack.Item key={preset.quick_access_slot}>
                              <Button
                                style={{
                                  minWidth: '32px',
                                  maxWidth: '40px',
                                  textAlign: 'center',
                                  backgroundColor: getBackgroundColor(
                                    preset.bottle_color,
                                  ),
                                  color: '#ffffff',
                                  textShadow:
                                    '0px 0px 2px #000000, -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000',
                                  fontWeight: 'bold',
                                  padding: '0 2px',
                                  marginRight: '2px',
                                  marginBottom: '2px',
                                  overflow: 'hidden',
                                  textOverflow: 'ellipsis',
                                }}
                                onClick={() =>
                                  act('apply_preset', { name: presetName })
                                }
                              >
                                {preset.quick_access_label ||
                                  (preset.quick_access_slot !== undefined
                                    ? preset.quick_access_slot + 1
                                    : '')}
                              </Button>
                            </Stack.Item>
                          ))}
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Box>
              )}

            <Stack vertical>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Box>Beaker:</Box>
                  </Stack.Item>
                  <Stack.Item grow>
                    {beaker ? (
                      beaker.reagents_volume + 'u'
                    ) : (
                      <NoticeBox info>No beaker inserted.</NoticeBox>
                    )}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <PillBottle setPicker={setPillPicker} />
              </Stack.Item>
              <Stack.Item>
                {beaker && !is_connected && (
                  <Button fluid onClick={() => act('connect')}>
                    Connect Smartfridge
                  </Button>
                )}
              </Stack.Item>
            </Stack>
          </Section>
          {beaker && (
            <Section
              title="Beaker"
              buttons={
                <Button
                  icon={'eject'}
                  tooltip={'Remove beaker, and clear buffer.'}
                  onClick={() => act('eject')}
                >
                  Eject
                </Button>
              }
            >
              {beaker.reagents ? (
                <Reagents reagents={beaker.reagents} type={'beaker'} />
              ) : (
                <NoticeBox info>Beaker is empty.</NoticeBox>
              )}
            </Section>
          )}
          <Section
            title="Buffer"
            buttons={
              <Button
                icon={mode ? 'toggle-on' : 'toggle-off'}
                onClick={() => act('toggle')}
              >
                {mode ? 'To Beaker' : 'To Disposal'}
              </Button>
            }
          >
            {buffer?.length ? (
              <Reagents reagents={buffer} type="buffer" />
            ) : (
              <NoticeBox info>Buffer is empty.</NoticeBox>
            )}
          </Section>
          <Glassware setPicker={setGlasswarePicker} />
          {glasswarePicker && (
            <GlasswarePicker
              setPicker={setGlasswarePicker}
              type={glasswarePicker}
            />
          )}
          {pillPicker && <PillPicker setPicker={setPillPicker} />}
        </Section>
        {showPresets && (
          <Modal className="ChemMaster__PresetModal" width="400px">
            <Box p="1rem">
              <Stack vertical>
                {/* Header */}
                <Stack.Item>
                  <Stack align="center" mb="1rem">
                    <Stack.Item grow>
                      <Box fontSize="16px" fontWeight="bold">
                        Preset Management
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="times"
                        onClick={() => setShowPresets(false)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* Preset List */}
                <Stack.Item grow>
                  <Stack align="center" mb="0.5rem">
                    <Stack.Item>
                      <Box fontWeight="bold">Saved Presets:</Box>
                    </Stack.Item>
                    <Stack.Item ml="auto">
                      <Stack>
                        <Stack.Item>
                          <Button
                            icon={showQuickAccess ? 'bolt' : 'bolt-lightning'}
                            onClick={() => setShowQuickAccess(!showQuickAccess)}
                            color={showQuickAccess ? 'good' : undefined}
                            style={{
                              backgroundColor: showQuickAccess
                                ? 'rgba(0, 255, 0, 0.3)'
                                : undefined,
                              transition: 'all 0.2s ease',
                            }}
                          >
                            {showQuickAccess
                              ? 'Hide Quick Access'
                              : 'Show Quick Access'}
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon={showReorderButtons ? 'times' : 'arrows-alt-v'}
                            onClick={() =>
                              setShowReorderButtons(!showReorderButtons)
                            }
                            color={showReorderButtons ? 'good' : undefined}
                            style={{
                              backgroundColor: showReorderButtons
                                ? 'rgba(0, 255, 0, 0.3)'
                                : undefined,
                              transition: 'all 0.2s ease',
                            }}
                          >
                            {showReorderButtons ? 'Hide' : 'Reorder'}
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  </Stack>
                  <Box
                    style={{
                      height: '300px',
                      overflowY: 'auto',
                      border: showReorderButtons
                        ? '1px solid rgba(0, 255, 0, 0.3)'
                        : undefined,
                      borderRadius: '4px',
                      padding: showReorderButtons ? '4px' : undefined,
                      transition: 'all 0.2s ease',
                    }}
                  >
                    {data.presets && Object.keys(data.presets).length ? (
                      Object.keys(data.presets)
                        .sort((a, b) => {
                          const orderA = data.presets[a].order || 0;
                          const orderB = data.presets[b].order || 0;
                          return orderA - orderB;
                        })
                        .map((presetName, index) => (
                          <Stack key={presetName} vertical mb="0.5rem">
                            {/* Preset Main Row */}
                            <Stack align="center">
                              {/* Preview Icons */}
                              <Stack.Item>
                                <Stack align="center">
                                  {data.presets[presetName].bottle_color && (
                                    <Stack.Item mr={1}>
                                      <Box width="32px" height="32px">
                                        <DmIcon
                                          icon={data.color_pill.icon}
                                          icon_state={`${data.color_pill.base}${data.color_pill.colors[data.presets[presetName].bottle_color]}`}
                                          height="32px"
                                          width="32px"
                                        />
                                      </Box>
                                    </Stack.Item>
                                  )}
                                  {data.presets[presetName].pill_color && (
                                    <Stack.Item
                                      style={{
                                        marginLeft: data.presets[presetName]
                                          .bottle_color
                                          ? '-16px'
                                          : '0',
                                      }}
                                    >
                                      <Box width="32px" height="32px">
                                        <DmIcon
                                          icon={data.pill_or_bottle_icon}
                                          icon_state={`pill${data.presets[presetName].pill_color}`}
                                          height="32px"
                                          width="32px"
                                        />
                                      </Box>
                                    </Stack.Item>
                                  )}
                                </Stack>
                              </Stack.Item>
                              <Stack.Item grow>
                                <Button
                                  fluid
                                  onClick={handlePresetApply(presetName)}
                                  style={{
                                    maxWidth: '100%',
                                    overflow: 'hidden',
                                    textOverflow: 'ellipsis',
                                    whiteSpace: 'nowrap',
                                  }}
                                >
                                  <Box
                                    style={{
                                      overflow: 'hidden',
                                      textOverflow: 'ellipsis',
                                      whiteSpace: 'nowrap',
                                    }}
                                  >
                                    {presetName}
                                    {data.presets[presetName].bottle_label && (
                                      <Box
                                        as="span"
                                        ml={1}
                                        opacity={0.7}
                                        fontSize="90%"
                                      >
                                        &quot;
                                        {data.presets[presetName].bottle_label}
                                        &quot;
                                      </Box>
                                    )}
                                    {showQuickAccess &&
                                      data.presets[presetName]
                                        .quick_access_slot !== undefined && (
                                        <Box
                                          as="span"
                                          ml={1}
                                          color="good"
                                          fontSize="90%"
                                        >
                                          [Q
                                          {data.presets[presetName]
                                            .quick_access_slot + 1}
                                          ]
                                        </Box>
                                      )}
                                  </Box>
                                </Button>
                              </Stack.Item>
                              <Stack.Item style={{ flexShrink: '0' }}>
                                <Stack>
                                  {showReorderButtons && (
                                    <>
                                      <Stack.Item>
                                        <Button
                                          icon="arrow-up"
                                          disabled={index === 0}
                                          onClick={handlePresetReorder(
                                            presetName,
                                            'up',
                                          )}
                                          style={{
                                            transform: showReorderButtons
                                              ? 'scale(1.1)'
                                              : undefined,
                                            transition: 'all 0.2s ease',
                                            backgroundColor: showReorderButtons
                                              ? 'rgba(0, 255, 0, 0.1)'
                                              : undefined,
                                          }}
                                        />
                                      </Stack.Item>
                                      <Stack.Item>
                                        <Button
                                          icon="arrow-down"
                                          disabled={
                                            index ===
                                            Object.keys(data.presets).length - 1
                                          }
                                          onClick={handlePresetReorder(
                                            presetName,
                                            'down',
                                          )}
                                          style={{
                                            transform: showReorderButtons
                                              ? 'scale(1.1)'
                                              : undefined,
                                            transition: 'all 0.2s ease',
                                            backgroundColor: showReorderButtons
                                              ? 'rgba(0, 255, 0, 0.1)'
                                              : undefined,
                                          }}
                                        />
                                      </Stack.Item>
                                    </>
                                  )}
                                  <Stack.Item>
                                    <Button
                                      icon={
                                        data.presets[presetName]
                                          .quick_access_slot !== undefined
                                          ? 'bolt'
                                          : 'bolt-lightning'
                                      }
                                      color={
                                        data.presets[presetName]
                                          .quick_access_slot !== undefined
                                          ? 'good'
                                          : undefined
                                      }
                                      tooltip={
                                        data.presets[presetName]
                                          .quick_access_slot !== undefined
                                          ? 'Edit quick access'
                                          : 'Add to quick access'
                                      }
                                      onClick={(e) => {
                                        e.stopPropagation();
                                        // Toggle quick access options for this preset only
                                        if (deletingPreset === presetName) {
                                          setDeletingPreset(null);
                                        }
                                        setShowQuickAccessOptions(
                                          showQuickAccessOptions === presetName
                                            ? null
                                            : presetName,
                                        );
                                      }}
                                      style={{
                                        display: showQuickAccess
                                          ? 'block'
                                          : 'none',
                                      }}
                                    />
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button
                                      icon="edit"
                                      onClick={handlePresetEdit(presetName)}
                                    />
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button
                                      icon="trash"
                                      color="bad"
                                      onClick={handlePresetDelete(presetName)}
                                    >
                                      {deletingPreset === presetName
                                        ? 'Confirm?'
                                        : ''}
                                    </Button>
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                            </Stack>

                            {/* Quick Access Options*/}
                            {(showQuickAccessOptions === presetName ||
                              showQuickAccessOptions === 'all') &&
                              showQuickAccess && (
                                <Box
                                  mt={1}
                                  mb={2}
                                  style={{
                                    padding: '8px',
                                    border:
                                      '1px solid rgba(120, 120, 120, 0.4)',
                                    borderRadius: '4px',
                                    backgroundColor: 'rgba(20, 20, 20, 0.4)',
                                    maxWidth: '100%',
                                    overflowX: 'hidden',
                                  }}
                                >
                                  <Stack vertical>
                                    <Stack.Item>
                                      <Box
                                        mb={1}
                                        fontWeight="bold"
                                        color="label"
                                      >
                                        Quick Access Slot:
                                      </Box>
                                      <Stack wrap>
                                        {[...Array(9)].map((_, i) => {
                                          // Check if this slot is used by any preset
                                          const isUsedByOther = Object.entries(
                                            data.presets,
                                          ).some(
                                            ([otherName, otherPreset]) =>
                                              otherName !== presetName &&
                                              otherPreset.quick_access_slot ===
                                                i,
                                          );
                                          const isSelected =
                                            data.presets[presetName]
                                              .quick_access_slot === i;

                                          return (
                                            <Stack.Item key={i}>
                                              <Button
                                                compact
                                                disabled={isUsedByOther ? 1 : 0}
                                                selected={isSelected ? 1 : 0}
                                                color={
                                                  isSelected
                                                    ? 'good'
                                                    : undefined
                                                }
                                                onClick={(e) => {
                                                  e.stopPropagation();
                                                  act('set_quick_access', {
                                                    name: presetName,
                                                    slot: isSelected ? null : i,
                                                  });
                                                }}
                                                style={{
                                                  width: '24px',
                                                  minWidth: '24px',
                                                  textAlign: 'center',
                                                  padding: '0 2px',
                                                }}
                                              >
                                                {i + 1}
                                              </Button>
                                            </Stack.Item>
                                          );
                                        })}
                                      </Stack>
                                    </Stack.Item>
                                    {data.presets[presetName]
                                      .quick_access_slot !== undefined && (
                                      <Stack.Item mt={1}>
                                        <Stack align="center">
                                          <Stack.Item>
                                            <Box color="label">
                                              Button Text:
                                            </Box>
                                          </Stack.Item>
                                          <Stack.Item>
                                            <Input
                                              width="64px"
                                              maxLength={3}
                                              value={
                                                data.presets[presetName]
                                                  .quick_access_label || ''
                                              }
                                              placeholder={
                                                // Use bottle label if available
                                                data.presets[presetName]
                                                  .bottle_label
                                                  ? data.presets[
                                                      presetName
                                                    ].bottle_label.substring(
                                                      0,
                                                      3,
                                                    )
                                                  : (
                                                      data.presets[presetName]
                                                        .quick_access_slot + 1
                                                    ).toString()
                                              }
                                              onChange={(e, value) => {
                                                act('set_quick_access_label', {
                                                  name: presetName,
                                                  label: sanitizeText(
                                                    value,
                                                  ).substring(0, 3),
                                                });
                                              }}
                                            />
                                          </Stack.Item>
                                        </Stack>
                                      </Stack.Item>
                                    )}
                                  </Stack>
                                </Box>
                              )}
                          </Stack>
                        ))
                    ) : (
                      <Box color="gray">No saved presets.</Box>
                    )}
                  </Box>
                </Stack.Item>

                {/* Create Button */}
                <Stack.Item mt="1rem">
                  <Button
                    icon="plus"
                    fluid
                    onClick={() => {
                      // Clear all fields before opening new preset form
                      setEditingPreset(null);
                      setPresetName('');
                      setSelectedPillBottleColor(null);
                      setPillBottleLabel('');
                      setSelectedPillColor(null);
                      setUsePresetNameAsLabel(false);
                      setCreatingPreset(true);
                      setShowPresets(false);
                    }}
                  >
                    Create New Preset
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          </Modal>
        )}
        {creatingPreset && (
          <Modal className="ChemMaster__PresetModal" width="400px">
            <Box p="1rem">
              <Stack vertical>
                {/* Header */}
                <Stack.Item>
                  <Stack align="center" mb="1rem">
                    <Stack.Item grow>
                      <Box fontSize="16px" fontWeight="bold">
                        {editingPreset
                          ? `Edit Preset: ${editingPreset}`
                          : 'Create New Preset'}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="times"
                        onClick={() => {
                          setCreatingPreset(false);
                          setEditingPreset(null);
                          // Reset form values
                          setPresetName('');
                          setSelectedPillBottleColor(null);
                          setPillBottleLabel('');
                          setSelectedPillColor(null);
                          setUsePresetNameAsLabel(false);
                          setShowPresets(true);
                        }}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* Preset Form */}
                <Stack.Item>
                  <Box mb="0.5rem">
                    Preset Name:{' '}
                    <Box as="span" color="red">
                      *
                    </Box>
                  </Box>
                  <Input
                    fluid
                    mb="1rem"
                    placeholder="Enter preset name"
                    value={presetName || editingPreset || ''}
                    onChange={(_, value) => setPresetName(value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Box mb="0.5rem">
                    Pill Bottle Color:{' '}
                    <Box as="span" style={{ fontStyle: 'italic' }}>
                      (optional)
                    </Box>
                  </Box>
                  <Stack align="center">
                    <Stack.Item grow basis={0}>
                      <Box
                        className="icon"
                        width="40px"
                        height="40px"
                        style={{
                          cursor: 'pointer',
                          border: '1px solid #666',
                          borderRadius: '4px',
                          padding: '4px',
                        }}
                        onClick={() => setPillBottleColorPicker(true)}
                      >
                        {selectedPillBottleColor ? (
                          <DmIcon
                            icon={data.color_pill.icon}
                            icon_state={`${data.color_pill.base}${data.color_pill.colors[selectedPillBottleColor]}`}
                            height="40px"
                            width="40px"
                          />
                        ) : (
                          <Box
                            textAlign="center"
                            lineHeight="32px"
                            fontSize="11px"
                            style={{
                              width: '32px',
                              height: '32px',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              overflow: 'hidden',
                              padding: '0 3px',
                            }}
                          >
                            Select
                          </Box>
                        )}
                      </Box>
                    </Stack.Item>
                    <Stack.Item basis={0} grow ml={1}>
                      <Button
                        fluid
                        icon="times"
                        disabled={!selectedPillBottleColor}
                        onClick={() => setSelectedPillBottleColor(null)}
                      >
                        Clear
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mb="0.5rem">
                    Pill Bottle Label:{' '}
                    <Box as="span" style={{ fontStyle: 'italic' }}>
                      (optional, max 3 characters)
                    </Box>
                  </Box>
                  <Input
                    fluid
                    mb="1rem"
                    placeholder="Enter pill bottle label"
                    value={
                      editingPreset && data.presets[editingPreset]
                        ? data.presets[editingPreset].bottle_label ||
                          pillBottleLabel
                        : pillBottleLabel
                    }
                    maxLength={3}
                    onChange={(_, value) => setPillBottleLabel(value)}
                  />
                </Stack.Item>

                <Stack.Item mb="1rem">
                  <Box mb="0.5rem">Additional Options:</Box>
                  <Stack vertical>
                    <Stack.Item>
                      <Button.Checkbox
                        checked={!!usePresetNameAsLabel}
                        onClick={() =>
                          setUsePresetNameAsLabel(!usePresetNameAsLabel)
                        }
                        mb="0.5rem"
                      >
                        Use preset name for bottle name
                      </Button.Checkbox>
                    </Stack.Item>
                    {usePresetNameAsLabel && (
                      <Stack.Item>
                        <Box
                          ml="1.5rem"
                          color="label"
                          fontSize="0.9em"
                          style={{ fontStyle: 'italic' }}
                        >
                          The short label above will be displayed on the icon,{' '}
                          but the full preset name &quot;
                          {sanitizeText(presetName || editingPreset || '')}
                          &quot; will be used when inspected.
                        </Box>
                      </Stack.Item>
                    )}
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Box mb="0.5rem">
                    Pill Color:{' '}
                    <Box as="span" style={{ fontStyle: 'italic' }}>
                      (optional)
                    </Box>
                  </Box>
                  <Stack align="center">
                    <Stack.Item grow basis={0}>
                      <Box
                        className="icon"
                        width="40px"
                        height="40px"
                        style={{
                          cursor: 'pointer',
                          border: '1px solid #666',
                          borderRadius: '4px',
                          padding: '4px',
                        }}
                        onClick={() => setPillColorPicker(true)}
                      >
                        {selectedPillColor ? (
                          <DmIcon
                            icon={data.pill_or_bottle_icon}
                            icon_state={`pill${selectedPillColor}`}
                            height="40px"
                            width="40px"
                          />
                        ) : (
                          <Box
                            textAlign="center"
                            lineHeight="32px"
                            fontSize="11px"
                            style={{
                              width: '32px',
                              height: '32px',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              overflow: 'hidden',
                              padding: '0 3px',
                            }}
                          >
                            Select
                          </Box>
                        )}
                      </Box>
                    </Stack.Item>
                    <Stack.Item basis={0} grow ml={1}>
                      <Button
                        fluid
                        icon="times"
                        disabled={!selectedPillColor}
                        onClick={() => setSelectedPillColor(null)}
                      >
                        Clear
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* Action Buttons */}
                <Stack.Item mt="1rem">
                  <Stack>
                    <Stack.Item grow basis={0}>
                      <Button
                        fluid
                        icon="save"
                        color={
                          showOverwriteWarning
                            ? 'bad'
                            : presetName
                              ? 'good'
                              : 'default'
                        }
                        disabled={!presetName && !editingPreset}
                        onClick={savePreset}
                      >
                        {showOverwriteWarning ? 'Overwrite?' : 'Save'}
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Box>
          </Modal>
        )}
        {pillBottleColorPicker && (
          <Modal>
            <Box p="1rem">
              <Stack vertical>
                <Stack.Item>
                  <Stack align="center" mb="1rem">
                    <Stack.Item grow>
                      <Box fontWeight="bold">Select Pill Bottle Color</Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="times"
                        onClick={() => setPillBottleColorPicker(false)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Stack width="17rem" wrap>
                    {Object.keys(data.color_pill.colors).map((color) => (
                      <Stack.Item key={color} mr={1} mb={1} className="picker">
                        <Box
                          className="icon"
                          onClick={() => {
                            setSelectedPillBottleColor(color);
                            setPillBottleColorPicker(false);
                          }}
                        >
                          <DmIcon
                            icon={data.color_pill.icon}
                            icon_state={`${data.color_pill.base}${data.color_pill.colors[color]}`}
                            height="32px"
                            width="32px"
                          />
                        </Box>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>

                <Stack.Item mt="1rem">
                  <Button
                    fluid
                    icon="times"
                    onClick={() => {
                      setSelectedPillBottleColor(null);
                      setPillBottleColorPicker(false);
                    }}
                  >
                    Clear Selection
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          </Modal>
        )}
        {pillColorPicker && (
          <Modal>
            <Box p="1rem">
              <Stack vertical>
                <Stack.Item>
                  <Stack align="center" mb="1rem">
                    <Stack.Item grow>
                      <Box fontWeight="bold">Select Pill Color</Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="times"
                        onClick={() => setPillColorPicker(false)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item>
                  <Stack width="17rem" wrap>
                    {Array.from(
                      {
                        length: data.pill_icon_choices,
                      },
                      (_, index) => (
                        <Stack.Item
                          key={index}
                          mr={1}
                          mb={1}
                          className="picker"
                        >
                          <Box
                            className="icon"
                            onClick={() => {
                              setSelectedPillColor(index + 1);
                              setPillColorPicker(false);
                            }}
                          >
                            <DmIcon
                              icon={data.pill_or_bottle_icon}
                              icon_state={`pill${index + 1}`}
                              height="32px"
                              width="32px"
                            />
                          </Box>
                        </Stack.Item>
                      ),
                    )}
                  </Stack>
                </Stack.Item>

                <Stack.Item mt="1rem">
                  <Button
                    fluid
                    icon="times"
                    onClick={() => {
                      setSelectedPillColor(null);
                      setPillColorPicker(false);
                    }}
                  >
                    Clear Selection
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          </Modal>
        )}
      </Window.Content>
    </Window>
  );
};

const PillPicker = (props: { readonly setPicker: (_) => void }) => {
  const { setPicker } = props;

  const { act, data } = useBackend<ChemMasterData>();

  const { color_pill } = data;

  return (
    <Modal m="1 rem">
      <Stack width="17rem" wrap>
        {Object.keys(color_pill.colors).map((color) => (
          <Stack.Item key={color} mr={1} mb={1} className="picker">
            <Box
              className="icon"
              onClick={() => {
                act('color_pill', { color: color });
                setPicker(false);
              }}
            >
              <DmIcon
                icon={color_pill.icon}
                icon_state={`${color_pill.base}${color_pill.colors[color]}`}
                height="32px"
                width="32px"
              />
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Modal>
  );
};

const GlasswarePicker = (props: {
  readonly setPicker: (_) => void;
  readonly type: 'pill' | 'bottle';
}) => {
  const { act, data } = useBackend<ChemMasterData>();

  const { pill_icon_choices, bottle_icon_choices, pill_or_bottle_icon } = data;

  const { setPicker, type } = props;

  return (
    <Modal m="1rem">
      <Stack width="17rem" wrap>
        {Array.from(
          {
            length: type === 'pill' ? pill_icon_choices : bottle_icon_choices,
          },
          (_, index) => (
            <Stack.Item key={index} mr={1} mb={1} className="picker">
              <Box
                className="icon"
                onClick={() => {
                  act(type === 'pill' ? 'change_pill' : 'change_bottle', {
                    picked: index + 1,
                  });
                  setPicker(false);
                }}
              >
                <DmIcon
                  icon={pill_or_bottle_icon}
                  icon_state={
                    type === 'pill' ? `pill${index + 1}` : `bottle-${index + 1}`
                  }
                  height="32px"
                  width="32px"
                />
              </Box>
            </Stack.Item>
          ),
        )}
      </Stack>
    </Modal>
  );
};

const PillBottle = (props: { readonly setPicker: (_) => void }) => {
  const { data, act } = useBackend<ChemMasterData>();

  const { setPicker } = props;

  const { pill_bottles, is_connected, color_pill } = data;

  return (
    <Stack>
      <Stack.Item>
        <Box>Pill Bottle{pill_bottles.length > 1 ? 's' : ''}:</Box>
      </Stack.Item>
      <Stack.Item grow>
        {pill_bottles.length ? (
          pill_bottles.map((pill_bottle, index) => (
            <Stack key={index} justify="space-between">
              <Stack.Item>
                <Stack>
                  {pill_bottles.length > 1 && (
                    <Stack.Item>
                      <Button.Checkbox
                        width="100%"
                        checked={pill_bottle.isNeedsToBeFilled}
                        onClick={() =>
                          act('check_pill_bottle', {
                            bottleIndex: index,
                            value: !pill_bottle.isNeedsToBeFilled,
                          })
                        }
                      >
                        Fill bottle
                      </Button.Checkbox>
                    </Stack.Item>
                  )}
                  <Stack.Item>
                    <Box>
                      {pill_bottle.size} / {pill_bottle.max_size}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    {pill_bottle.label && <Box>({pill_bottle.label})</Box>}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              {index === 0 ? (
                <Stack>
                  <Stack.Item>
                    <Button.Input
                      onCommit={(_, value) => {
                        act('label_pill', {
                          text: sanitizeText(value).substring(0, 3),
                          bottleIndex: index,
                        });
                      }}
                    >
                      <Icon name={'tag'} /> Label
                    </Button.Input>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => setPicker(true)} height="1.75rem">
                      <DmIcon
                        mt={-1.5}
                        icon={color_pill.icon}
                        icon_state={pill_bottle.icon_state}
                      />
                    </Button>
                  </Stack.Item>
                </Stack>
              ) : (
                <Stack>
                  <Stack.Item>
                    <DmIcon
                      mt={-1.5}
                      icon={color_pill.icon}
                      icon_state={pill_bottle.icon_state}
                    />
                  </Stack.Item>
                </Stack>
              )}
              <Stack>
                {!!is_connected && (
                  <Stack.Item>
                    <Button
                      icon={'arrow-up'}
                      onClick={() =>
                        act('transfer_pill', { bottleIndex: index })
                      }
                    >
                      Transfer
                    </Button>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Button
                    icon={'eject'}
                    onClick={() => act('eject_pill', { bottleIndex: index })}
                  >
                    Eject
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack>
          ))
        ) : (
          <NoticeBox info>No pill bottles inserted.</NoticeBox>
        )}
      </Stack.Item>
    </Stack>
  );
};

const Glassware = (props: { readonly setPicker: (type) => void }) => {
  const { data, act } = useBackend<ChemMasterData>();

  const { setPicker } = props;

  const {
    pill_or_bottle_icon,
    pillsprite,
    is_pillmaker,
    is_condiment,
    is_connected,
    is_vialmaker,
    bottlesprite,
    internal_reagent_name,
    buffer,
  } = data;

  const [numPills, setNumPills] = useSharedState('pillNum', 16);

  return (
    <Section title="Glassware">
      {!is_condiment ? (
        <Stack>
          <Stack.Item>
            {!!is_pillmaker && (
              <Stack>
                <Button
                  lineHeight={'35px'}
                  disabled={!buffer}
                  onClick={() => act('create_pill', { number: numPills })}
                >
                  Create Pill{numPills > 1 ? 's' : ''}
                </Button>
                <Box className="icon" onClick={() => setPicker('pill')}>
                  <DmIcon
                    icon={pill_or_bottle_icon}
                    icon_state={`pill${pillsprite}`}
                    height="32px"
                    width="32px"
                  />
                </Box>
                <NumberInput
                  value={numPills}
                  maxValue={20}
                  minValue={1}
                  step={1}
                  stepPixelSize={3}
                  width="30px"
                  onChange={(value) => setNumPills(value)}
                />
              </Stack>
            )}
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack vertical>
                <Button.Input
                  disabled={!buffer}
                  height={'100%'}
                  lineHeight={is_connected ? '' : '35px'}
                  currentValue={internal_reagent_name}
                  onCommit={(_, value) =>
                    act('create_glass', {
                      type: 'glass',
                      label: value,
                    })
                  }
                >
                  Create Bottle (60u)
                </Button.Input>
                {!!is_connected && (
                  <Button.Input
                    disabled={!buffer}
                    currentValue={internal_reagent_name}
                    onCommit={(_, value) =>
                      act('create_glass', {
                        type: 'glass',
                        label: value,
                        store: true,
                      })
                    }
                  >
                    Create and Transfer
                  </Button.Input>
                )}
              </Stack>
              <Box className="icon" onClick={() => setPicker('bottle')}>
                <DmIcon
                  icon={pill_or_bottle_icon}
                  icon_state={`bottle-${bottlesprite}`}
                  height="32px"
                  width="32px"
                />
              </Box>
            </Stack>
          </Stack.Item>
          {!!is_vialmaker && (
            <Stack.Item>
              <Stack vertical>
                <Button.Input
                  disabled={!buffer}
                  height={'100%'}
                  lineHeight={is_connected ? '' : '35px'}
                  currentValue={internal_reagent_name}
                  onCommit={(_, value) =>
                    act('create_glass', { type: 'vial', label: value })
                  }
                >
                  Create Vial (30u)
                </Button.Input>
                {!!is_connected && (
                  <Button.Input
                    disabled={!buffer}
                    currentValue={internal_reagent_name}
                    onCommit={(_, value) =>
                      act('create_glass', {
                        type: 'vial',
                        label: value,
                        store: true,
                      })
                    }
                  >
                    Create and Transfer
                  </Button.Input>
                )}
              </Stack>
            </Stack.Item>
          )}
        </Stack>
      ) : (
        <Button onClick={() => act('create_glass')} disabled={!buffer}>
          Create Bottle (50u)
        </Button>
      )}
    </Section>
  );
};

const Reagents = (props: {
  readonly reagents: Reagent[];
  readonly type: 'beaker' | 'buffer';
}) => {
  const { reagents, type } = props;

  const { act } = useBackend();

  return (
    <Stack vertical>
      {reagents.map((reagent) => (
        <Stack.Item key={reagent.id}>
          <Stack justify="space-between">
            <Stack.Item>
              {reagent.name}, {reagent.volume} units
            </Stack.Item>
            <Stack>
              <ReagentButton amount={1} reagent={reagent} type={type} />
              <ReagentButton amount={5} reagent={reagent} type={type} />
              <ReagentButton amount={10} reagent={reagent} type={type} />
              <ReagentButton amount={30} reagent={reagent} type={type} />
              <ReagentButton amount={60} reagent={reagent} type={type} />
              <ReagentButton amount={'All'} reagent={reagent} type={type} />
              <Stack.Item>
                <Input
                  placeholder="Custom"
                  onEnter={(_, value) => {
                    act(type === 'beaker' ? 'add' : 'remove', {
                      amount: parseInt(value, 10),
                      id: reagent.id,
                    });
                  }}
                />
              </Stack.Item>
            </Stack>
          </Stack>
        </Stack.Item>
      ))}
      <Stack.Item>
        <Button
          fluid
          onClick={() => act(type === 'beaker' ? 'add_all' : 'remove_all')}
        >
          All Reagents
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const ReagentButton = (props: {
  readonly amount: number | 'All';
  readonly reagent: Reagent;
  readonly type: 'buffer' | 'beaker';
}) => {
  const { act } = useBackend();

  const { amount, reagent, type } = props;

  return (
    <Stack.Item>
      <Button
        onClick={() => {
          act(type === 'beaker' ? 'add' : 'remove', {
            amount: amount === 'All' ? reagent.volume : amount,
            id: reagent.id,
          });
        }}
      >
        {amount}
      </Button>
    </Stack.Item>
  );
};
