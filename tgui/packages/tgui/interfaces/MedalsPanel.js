import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Flex, Button, Fragment } from '../components';
import { Window } from '../layouts';

const PAGES = [
  {
    title: 'USCM',
    component: () => USCMPage,
    color: "blue",
    icon: "medal",
  },
  {
    title: 'Hive',
    component: () => HivePage,
    color: "purple",
    icon: "star",
  },
];

export const MedalsPanel = (props, context) => {
  const { data } = useBackend(context);
  
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 1);
  
  const PageComponent = PAGES[pageIndex].component();
  
  return (
    <Window
      width={600}
      height={400}
      theme={pageIndex === 0 ? "ntos" : "hive_status"}
      resizable
    >
      <Window.Content scrollable>
        <Tabs>
          {PAGES.map((page, i) => {
            if (page.canAccess && !page.canAccess(data)) {
              return;
            }
  
            return (
              <Tabs.Tab
                key={i}
                color={page.color}
                selected={i === pageIndex}
                icon={page.icon}
                onClick={() => setPageIndex(i)}>
                {page.title}
              </Tabs.Tab>
            );
          })}
        </Tabs>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const USCMPage = (props, context) => {
  const { act, data } = useBackend(context);
  const { uscm_awards } = data;

  return (
    <Section title="Medal Awards" buttons={(
      <Fragment>
        <Button
          icon="clock"
          content="Refresh"
          ml={0.5}
          onClick={() => act("refresh")} />
        <Button
          icon="plus"
          color="green"
          content="Add a medal"
          align="center"
          width={8.5}
          ml={0.5}
          onClick={() => act("add_medal")} />
      </Fragment>
    )}>
      <Flex direction="column">
        {Object.keys(uscm_awards)
          .map((recipient_name, recipient_index) => (
            <Section title={recipient_name} key={recipient_index} m={1}>
              {Object(uscm_awards[recipient_name])
                .map((medal, medalIndex) => (
                  <Flex direction="row" key={medalIndex} backgroundColor={medalIndex % 2 === 1 ? "rgba(255,255,255,0.1)" : ""}>
                    <Flex.Item grow={1} align="center" ml={0.5}>
                      A {medal}
                    </Flex.Item>
                    <Flex.Item grow={0} basis="content" m={0.5}>
                      <Button.Confirm
                        icon="trash"
                        color="white"
                        content="Rescind"
                        confirmColor="bad"
                        width={6.5}
                        textAlign="center"
                        verticalAlignContent="bottom"
                        onClick={() => act("delete_medal", {
                          recipient: recipient_name,
                          index: medalIndex,
                        })}
                      />
                    </Flex.Item>
                  </Flex>
                ))}
            </Section>
          ))}
      </Flex>
    </Section>
  );
};
  
const HivePage = (props, context) => {
  const { act, data } = useBackend(context);
  const { xeno_awards } = data;
  
  return (
    <Section title="Royal Jellies" buttons={(
      <Fragment>
        <Button
          icon="clock"
          content="Refresh"
          ml={0.5}
          onClick={() => act("refresh")} />
        <Button
          icon="plus"
          color="green"
          content="Add a jelly"
          align="center"
          width={8.5}
          ml={0.5}
          onClick={() => act("add_jelly")} />
      </Fragment>
    )}>
      <Flex direction="column">
        {Object.keys(xeno_awards)
          .map((recipient_name, recipient_index) => (
            <Section title={recipient_name} key={recipient_index} m={1}>
              {Object(xeno_awards[recipient_name])
                .map((medal, medalIndex) => (
                  <Flex direction="row" key={medalIndex} backgroundColor={medalIndex % 2 === 1 ? "rgba(255,255,255,0.1)" : ""}>
                    <Flex.Item grow={1} align="center" ml={0.5}>
                      A {medal}
                    </Flex.Item>
                    <Flex.Item grow={0} basis="content" m={0.5}>
                      <Button.Confirm
                        icon="trash"
                        color="white"
                        content="Rescind"
                        confirmColor="bad"
                        width={6.5}
                        textAlign="center"
                        verticalAlignContent="bottom"
                        onClick={() => act("delete_jelly", {
                          recipient: recipient_name,
                          index: medalIndex,
                        })}
                      />
                    </Flex.Item>
                  </Flex>
                ))}
            </Section>
          ))}
      </Flex>
    </Section>
  );
};
