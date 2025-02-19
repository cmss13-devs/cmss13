import { useBackend } from '../backend';
import { Button, NoticeBox, Stack } from '../components';
import { Window } from '../layouts';

export const NukeDiskGen = (props) => {
  const { act, data } = useBackend();
  const { security_protocol, interaction_time_lock, timer } = data;

  return (
    <Window width={300} height={400}>
      <Window.Content>
        <NoticeBox info>Security Terminal</NoticeBox>
        <NoticeBox danger>
          Security Protocol: {security_protocol ? 'On' : 'Off'}
        </NoticeBox>

        {security_protocol ? (
          <>
            <NoticeBox warning>Progress: {timer.current_progress}%</NoticeBox>
            <Stack>
              {security_protocol.messages.map((message, index) => (
                <Stack.Item key={index}>
                  <NoticeBox success>{message}</NoticeBox>
                </Stack.Item>
              ))}
            </Stack>
            <Button
              disabled={timer.running || interaction_time_lock}
              color="transparent"
              width={'200px'}
              lineHeight={1.75}
              content="System Link"
              style={{
                borderColor: '#37bc97',
                borderStyle: 'solid',
                borderWidth: '1px',
                color: '#9e8c39',
              }}
              onClick={() => act('security')}
            />
          </>
        ) : (
          <>
            <NoticeBox warning>
              Printing Progress: {timer.current_progress}%
            </NoticeBox>
            <Button
              disabled={interaction_time_lock}
              color="transparent"
              width={'200px'}
              lineHeight={1.75}
              content="Print Disk"
              style={{
                borderColor: '#37bc97',
                borderStyle: 'solid',
                borderWidth: '1px',
                color: '#9e8c39',
              }}
              onClick={() => act('print')}
            />
          </>
        )}
        <NoticeBox info>(C) W-Y General Security Systems</NoticeBox>
      </Window.Content>
    </Window>
  );
};
