import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export const TechControl = (props) => {
  const { act, data } = useBackend();
  data.leader_data = data.leader_data || {
    name: 'Unassigned',
    job: 'N/A',
    paygrade: 'N/A',
    rank: 0,
  };

  const { leader_data, user_data } = data;

  return (
    <Window width={500} height={250} resizable>
      <Window.Content>
        <Flex height="100%" justify="space-between">
          <Flex.Item grow={1}>
            <Flex direction="column" height="100%">
              <Flex.Item grow={1}>
                <Section fill title="Leader Data">
                  <Flex direction="column">
                    <Flex.Item>
                      <Label label="Name" content={leader_data.name} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="Job" content={leader_data.job} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="Paygrade" content={leader_data.paygrade} />
                    </Flex.Item>
                  </Flex>
                </Section>
              </Flex.Item>
              <Flex.Item>
                <Section fill title="Your Data">
                  <Flex direction="column">
                    <Flex.Item>
                      <Label label="Name" content={user_data.name} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="Job" content={user_data.job || 'N/A'} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label
                        label="Paygrade"
                        content={user_data.paygrade || 'N/A'}
                      />
                    </Flex.Item>
                  </Flex>
                </Section>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item ml={1}>
            <Section fill title="Commands">
              <Flex direction="column" height="100%">
                <Flex.Item>
                  <Button
                    disabled={
                      (user_data.rank || 0) < leader_data.rank ||
                      user_data.is_leader
                    }
                    textAlign="center"
                    width="100%"
                    onClick={() => act('override_leader')}
                  >
                    Take Command
                  </Button>
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Button
                    disabled={!user_data.is_leader}
                    color="red"
                    textAlign="center"
                    width="100%"
                    onClick={() => act('giveup_control')}
                  >
                    Resign Command
                  </Button>
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const Label = (props) => {
  const { label, content, ...rest } = props;

  return (
    <Flex {...rest}>
      <Flex.Item width="25%">
        <Box color="label">{label}:</Box>
      </Flex.Item>
      <Flex.Item width="75%">
        <Box className="TechNode__content">{content}</Box>
      </Flex.Item>
    </Flex>
  );
};
