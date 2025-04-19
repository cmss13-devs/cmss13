import { useBackend } from '../backend';
import { Button, Dropdown, Section, Stack } from '../components';
import { Window } from '../layouts';

export const GameMaster = (props, context) => {
  const { data, act } = useBackend();

  return (
    <Window width={400} height={500}>
      <Window.Content scrollable>
        <Stack direction="column" grow>
          <GameMasterSpawningPanel />

          <GameMasterBehaviorPanel />

          <GameMasterCommunicationPanel />
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const GameMasterSpawningPanel = (props, context) => {
  const { data, act } = useBackend();

  return (
    <Section title="Spawning">
      <Stack direction="column">
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button.Input
                ml={1}
                minWidth={3.5}
                minHeight={1.5}
                currentValue={data.xeno_spawn_count}
                onCommit={(e, value) => {
                  act('set_xeno_spawns', { value });
                }}
              >
                {data.xeno_spawn_count}
              </Button.Input>
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                options={data.spawnable_xenos}
                selected={data.selected_xeno}
                onSelected={(new_xeno) => {
                  act('set_selected_xeno', { new_xeno });
                }}
                menuWidth="10rem"
                width="10rem"
              />
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                options={data.spawnable_hives}
                selected={data.selected_hive}
                onSelected={(new_hive) => {
                  act('set_selected_hive', { new_hive });
                }}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button.Checkbox
                checked={data.spawn_ai}
                onClick={() => {
                  act('xeno_spawn_ai_toggle');
                }}
              >
                AI
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button
                selected={data.spawn_click_intercept}
                onClick={() => {
                  act('toggle_click_spawn');
                }}
              >
                Click Spawn
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button
                onClick={() => {
                  act('delete_all_xenos');
                }}
              >
                Delete all xenos
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() => {
                  act('delete_xenos_in_view');
                }}
              >
                Delete viewed xenos
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const GameMasterBehaviorPanel = (props, context) => {
  const { data, act } = useBackend();

  return (
    <Section title="Special Behaviors">
      <Stack direction="column">
        <Stack.Item>
          <Dropdown
            ml={1}
            options={data.selectable_behaviors}
            selected={data.selected_behavior}
            onSelected={(new_behavior) => {
              act('set_selected_behavior', { new_behavior });
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            selected={data.behavior_click_intercept}
            onClick={() => {
              act('toggle_click_behavior');
            }}
          >
            Click Behavior
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
