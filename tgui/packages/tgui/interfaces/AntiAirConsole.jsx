import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const AntiAirConsole = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={400} height={300}>
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props) => {
  const { act, data } = useBackend();

  const sections = data.sections;

  const [selectedSection, setSelectedSection] = useState(null);

  return (
    <Section fill>
      {(!!data.protecting_section && (
        <NoticeBox info textAlign="center">
          Currently tracking : {data.protecting_section}
        </NoticeBox>
      )) || (
        <NoticeBox danger textAlign="center">
          Warning! AA Cannon not active!
        </NoticeBox>
      )}
      <Stack vertical fill>
        <Stack.Item grow>
          <Section fill scrollable>
            <Tabs vertical>
              {sections.map((val) => {
                return (
                  <Tabs.Tab
                    selected={selectedSection === val.section_id}
                    onClick={() => {
                      if (selectedSection === val.section_id) {
                        act('protect', { section_id: selectedSection });
                      } else {
                        setSelectedSection(val.section_id);
                      }
                    }}
                    key={val.section_id}
                    onFocus={() =>
                      document.activeElement
                        ? document.activeElement.blur()
                        : false
                    }
                  >
                    {(!!(val.section_id === data.protecting_section) && (
                      <Box color="good">{val.section_id}</Box>
                    )) || <Box>{val.section_id}</Box>}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Section>
        </Stack.Item>
        <Stack.Item height="60px">
          <Button
            color="good"
            fluid
            textAlign="center"
            onClick={() => act('protect', { section_id: selectedSection })}
          >
            Set as section to track
          </Button>
          {!!data.protecting_section && (
            <Button.Confirm
              color="bad"
              fluid
              textAlign="center"
              onClick={() => act('deactivate')}
            >
              Stop tracking
            </Button.Confirm>
          )}
        </Stack.Item>
      </Stack>
      {!!data.disabled && (
        <Dimmer fontSize="32px">
          <Icon name="exclamation-triangle" />
          {' AA disabled!'}
        </Dimmer>
      )}
    </Section>
  );
};
