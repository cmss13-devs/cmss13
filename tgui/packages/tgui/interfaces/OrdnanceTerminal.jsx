import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const OrdnanceTerminal = () => {
  const { act, data } = useBackend();

  const { credits, tech_upgrades, categories } = data;
  const dropdownOptions = categories;
  const [selectedTab, setSelectedTab] = useState('NONE');

  return (
    <Window width={600} height={395} theme="crtblue">
      <Window.Content>
        <Section title="Technology">
          <NoticeBox info>Technology Credits : {credits}</NoticeBox>
        </Section>
        <Divider />
        <Section title={<span> Select Technology to print.</span>}>
          <Box ml={1}>
            <Dropdown
              selected={selectedTab}
              options={dropdownOptions}
              color={'#876500'}
              onSelected={(value) => setSelectedTab(value)}
            />
          </Box>
          <Flex height="200%" direction="row">
            <Flex.Item>
              <Box m={2} bold>
                {selectedTab !== 'NONE' && (
                  <LabeledList>
                    {tech_upgrades.map((tech_upgrades) =>
                      tech_upgrades.category === selectedTab ? (
                        <LabeledList.Item
                          key={tech_upgrades.name}
                          label={
                            <Box width={25}>
                              <h3 style={{ color: '#ffbf00' }}>
                                {tech_upgrades.name}
                              </h3>
                            </Box>
                          }
                          buttons={
                            <Box mb={1.5} width={5.5}>
                              <Button
                                fluid={1}
                                icon="print"
                                tooltip={tech_upgrades.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('buy', {
                                    ref: tech_upgrades.ref,
                                  })
                                }
                              >
                                Print
                              </Button>
                            </Box>
                          }
                        >
                          {' '}
                          <Box ml={7}>{tech_upgrades.cost} Credits</Box>
                        </LabeledList.Item>
                      ) : null,
                    )}
                  </LabeledList>
                )}
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
