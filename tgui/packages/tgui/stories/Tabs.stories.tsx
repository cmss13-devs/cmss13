/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { useState } from 'react';
import { Button, Section, Tabs } from 'tgui/components';

export const meta = {
  title: 'Tabs',
  render: () => <Story />,
};

type TabProps = {
  vertical: boolean;
  leftSlot: boolean;
  rightSlot: boolean;
  icon: boolean;
  fluid: boolean;
  centered: boolean;
};

const TAB_RANGE = ['Tab #1', 'Tab #2', 'Tab #3', 'Tab #4'];

const Story = (props) => {
  const [tabProps, setTabProps] = useState({} as TabProps);
  return (
    <>
      <Section>
        <Button.Checkbox
          inline
          checked={tabProps.vertical}
          onClick={() =>
            setTabProps({
              ...tabProps,
              vertical: !tabProps.vertical,
            })
          }
        >
          vertical
        </Button.Checkbox>
        <Button.Checkbox
          inline
          checked={tabProps.leftSlot}
          onClick={() =>
            setTabProps({
              ...tabProps,
              leftSlot: !tabProps.leftSlot,
            })
          }
        >
          leftSlot
        </Button.Checkbox>
        <Button.Checkbox
          inline
          checked={tabProps.rightSlot}
          onClick={() =>
            setTabProps({
              ...tabProps,
              rightSlot: !tabProps.rightSlot,
            })
          }
        >
          rightSlot
        </Button.Checkbox>
        <Button.Checkbox
          inline
          checked={tabProps.icon}
          onClick={() =>
            setTabProps({
              ...tabProps,
              icon: !tabProps.icon,
            })
          }
        >
          icon
        </Button.Checkbox>
        <Button.Checkbox
          inline
          checked={tabProps.fluid}
          onClick={() =>
            setTabProps({
              ...tabProps,
              fluid: !tabProps.fluid,
            })
          }
        >
          fluid
        </Button.Checkbox>
        <Button.Checkbox
          inline
          checked={tabProps.centered}
          onClick={() =>
            setTabProps({
              ...tabProps,
              centered: !tabProps.centered,
            })
          }
        >
          centered
        </Button.Checkbox>
      </Section>
      <Section fitted>
        <TabsPrefab tabProps={tabProps} />
      </Section>
      <Section title="Normal section">
        <TabsPrefab tabProps={tabProps} />
        Some text
      </Section>
      <Section>
        Section-less tabs appear the same as tabs in a fitted section:
      </Section>
      <TabsPrefab tabProps={tabProps} />
    </>
  );
};

const TabsPrefab = (props: { readonly tabProps: TabProps }) => {
  const [tabIndex, setTabIndex] = useState(0);
  const { tabProps } = props;
  return (
    <Tabs
      vertical={tabProps.vertical}
      fluid={tabProps.fluid}
      textAlign={tabProps.centered && 'center'}
    >
      {TAB_RANGE.map((text, i) => (
        <Tabs.Tab
          key={i}
          selected={i === tabIndex}
          icon={tabProps.icon ? 'info-circle' : undefined}
          leftSlot={
            tabProps.leftSlot && (
              <Button circular compact color="transparent" icon="times" />
            )
          }
          rightSlot={
            tabProps.rightSlot && (
              <Button circular compact color="transparent" icon="times" />
            )
          }
          onClick={() => setTabIndex(i)}
        >
          {text}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
