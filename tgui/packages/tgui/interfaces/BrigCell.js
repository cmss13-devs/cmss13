import { useBackend } from '../backend';
import { Window } from '../layouts';
import { NoticeBox, Flex, ProgressBar, Button, LabeledList, Divider } from '../components';

export const BrigCell = (props, context) => {
  const { data, act } = useBackend(context);
  const { viewing_incident, incidents } = data;

  return (
    <Window theme="weyland" width={450} height={445}>
      <Window.Content>
        <Flex justify="center" mt="2rem" mb=".5rem">
          <Button
            content="Toggle Doors"
            height="100%"
            mr="1rem"
            px="2rem"
            py=".25rem"
            onClick={() => act('toggle_doors')}
          />
          <Button
            content="Activate Flash"
            height="100%"
            px="2rem"
            py=".25rem"
            onClick={() => act('flash')}
          />
        </Flex>

        <Divider />

        <Flex direction="column" justify="center" align="center" width="auto">
          {!viewing_incident &&
            incidents.map((incident, i) => (
              <Button
                key={i}
                textAlign="center"
                minWidth="15rem"
                p=".5rem"
                my=".5rem"
                onClick={() =>
                  act('set_viewed_incident', { incident: incident.ref })
                }>
                {incident.suspect}
              </Button>
            ))}
        </Flex>

        {!!viewing_incident && <IncidentDetails />}
      </Window.Content>
    </Window>
  );
};

const IncidentDetails = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    suspect,
    progress,
    sentence,
    time_left,
    started,
    active,
    status_class,
    status_text,
  } = data;

  return (
    <>
      <Flex mb=".5rem" justify="space-between" align="center">
        <Button
          icon="arrow-left"
          px="2rem"
          py=".25rem"
          mr="1rem"
          onClick={() => act('set_viewed_incident')}
        />

        <Flex.Item>
          {status_text !== 'PERMABRIG' && (
            <Button.Confirm
              icon="rotate-left"
              px=".75rem"
              py=".25rem"
              mr="1rem"
              tooltip="Reset sentence"
              onClick={() => act('reset_timer')}
            />
          )}

          <Button.Confirm
            icon="eject"
            px=".75rem"
            py=".25rem"
            tooltip="Eject report"
            onClick={() => act('remove_report')}
          />
        </Flex.Item>
      </Flex>

      {!status_class && (
        <ProgressBar
          my="0rem"
          value={progress}
          p="1.25rem"
          color="average"
          style={{ border: 'none', margin: 0 }}>
          <Flex justify="center" fontSize="2rem" bold>
            {time_left}
          </Flex>
        </ProgressBar>
      )}

      {status_class && (
        <NoticeBox
          className={'NoticeBox--type--' + status_class}
          width="100%"
          textAlign="center"
          p="1rem"
          fontSize="2rem">
          {status_text}
        </NoticeBox>
      )}

      <Flex mt="1rem">
        <LabeledList>
          <LabeledList.Item label="Suspect">{suspect}</LabeledList.Item>
          <LabeledList.Item label="Sentence">{sentence}</LabeledList.Item>
        </LabeledList>
      </Flex>

      {(!status_class || status_text === 'PERMABRIG') && (
        <Flex>
          {!active && (
            <Button
              tooltip={started ? 'Resume Timer' : 'Start Timer'}
              icon="play"
              px="2rem"
              py=".25rem"
              mt="1rem"
              mr="1rem"
              onClick={() => act('start_timer')}
            />
          )}

          {!!active && (
            <>
              {status_text !== 'PERMABRIG' && (
                <Button
                  tooltip="Pause Timer"
                  icon="pause"
                  px="2rem"
                  py=".25rem"
                  mt="1rem"
                  mr="1rem"
                  height="100%"
                  onClick={() => act('pause_timer')}
                />
              )}

              <Button.Confirm
                tooltip="End Timer"
                icon="stop"
                px="2rem"
                py=".25rem"
                mt="1rem"
                mr="1rem"
                height="100%"
                onClick={() => act('end_timer')}
              />
            </>
          )}

          <Button.Confirm
            content="Pardon"
            tooltip="Pardon"
            icon="gavel"
            px="2rem"
            py=".25rem"
            mt="1rem"
            height="100%"
            onClick={() => act('pardon')}
          />
        </Flex>
      )}
    </>
  );
};
