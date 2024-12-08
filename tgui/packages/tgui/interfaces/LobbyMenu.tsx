import { BooleanLike } from 'common/react';
import { useEffect, useRef } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { BoxProps } from '../components/Box';
import { Window } from '../layouts';

type LobbyData = {
  icon: string;
  lobby_icon: string;

  sound: string;
  sound_interact: string;

  character_name: string;
  display_number: string;

  round_start: BooleanLike;
  readied: BooleanLike;

  upp_enabled: BooleanLike;
  xenomorph_enabled: BooleanLike;
  predator_enabled: BooleanLike;
  fax_responder_enabled: BooleanLike;
};

export const LobbyMenu = () => {
  const { act, data } = useBackend<LobbyData>();

  const ref = useRef<HTMLAudioElement>(null);
  const quiet = useRef<HTMLAudioElement>(null);

  useEffect(() => {
    quiet.current!.volume = 0.4;
  });

  return (
    <Window theme="crtgreen" fitted scrollbars={false}>
      <audio autoPlay src={data.sound} ref={quiet} />
      <audio src={data.sound_interact} ref={ref} />
      <Window.Content
        className="LobbyScreen"
        style={{
          backgroundPosition: 'center',
          backgroundSize: 'cover',
        }}
        fitted
        onClick={() => {
          ref.current!.play();
        }}
      >
        <Box
          height="100%"
          width="100%"
          style={{
            backgroundImage: `url(${data.lobby_icon})`,
            backgroundPosition: 'center',
            backgroundSize: 'cover',
            position: 'absolute',
          }}
          className="bgLoad"
        />
        <Box
          height="100%"
          width="100%"
          style={{
            position: 'absolute',
          }}
          className="crt"
        />
        <Stack vertical height="100%" justify="space-around" align="center">
          <Stack.Item>
            <LobbyButtons />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const LobbyButtons = () => {
  const { act, data } = useBackend<LobbyData>();

  const {
    character_name,
    display_number,
    round_start,
    readied,
    predator_enabled,
    fax_responder_enabled,
    upp_enabled,
  } = data;

  return (
    <Section p={3} className="sectionLoad" style={{ boxShadow: '0 0 15px' }}>
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Box height="68px">
                <Box
                  style={{
                    backgroundImage: `url("${data.icon}")`,
                  }}
                  width="67px"
                  className="loadEffect"
                />
              </Box>
            </Stack.Item>
            <Stack.Item width="200px">
              <Stack vertical>
                <Stack.Item>
                  <Stack justify="center">
                    <Stack.Item>
                      <Box className="typeEffect">Welcome,</Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack justify="center">
                    <Stack.Item>
                      <Box
                        className="typeEffect"
                        style={{
                          animationDelay: '1.4s',
                        }}
                      >
                        {character_name}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack justify="center">
                    <Stack.Item>
                      <Box
                        className="typeEffect hiveEffect"
                        style={{
                          animationDelay: '1.4s',
                        }}
                      >
                        {display_number}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <TimedDivider />

        <LobbyButton index={1} onClick={() => act('tutorial')}>
          Tutorial
        </LobbyButton>
        <LobbyButton index={2} onClick={() => act('preferences')}>
          Setup Character
        </LobbyButton>
        <LobbyButton index={3} onClick={() => act('playtimes')}>
          View Playtimes
        </LobbyButton>

        <TimedDivider />

        <LobbyButton index={4} onClick={() => act('observe')}>
          Observe
        </LobbyButton>

        {round_start ? (
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <LobbyButton
                  index={5}
                  disabled={!!readied}
                  onClick={() => act('ready')}
                >
                  Ready
                </LobbyButton>
              </Stack.Item>
              <Stack.Item grow>
                <LobbyButton
                  index={5}
                  disabled={!readied}
                  onClick={() => act('unready')}
                >
                  Not Ready
                </LobbyButton>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ) : (
          <>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <LobbyButton index={5} onClick={() => act('late_join')}>
                    Join the USCM!
                  </LobbyButton>
                </Stack.Item>
                <Stack.Item>
                  <LobbyButton
                    icon="list"
                    tooltip="View Crew Manifest"
                    index={8}
                    onClick={() => act('manifest')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <LobbyButton index={6} onClick={() => act('late_join_xeno')}>
                    Join the Hive
                  </LobbyButton>
                </Stack.Item>
                <Stack.Item>
                  <LobbyButton
                    icon="users-rays"
                    tooltip="View Hive Leaders"
                    index={9}
                    onClick={() => act('hiveleaders')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {!!upp_enabled && (
              <Stack.Item>
                <LobbyButton index={7} onClick={() => act('late_join_upp')}>
                  Join the UPP
                </LobbyButton>
              </Stack.Item>
            )}
            {!!predator_enabled && (
              <Stack.Item>
                <LobbyButton index={8} onClick={() => act('late_join_pred')}>
                  Join the Hunt
                </LobbyButton>
              </Stack.Item>
            )}
            {!!fax_responder_enabled && (
              <Stack.Item>
                <LobbyButton index={9} onClick={() => act('late_join_faxes')}>
                  Respond to Faxes
                </LobbyButton>
              </Stack.Item>
            )}
          </>
        )}
      </Stack>
    </Section>
  );
};

const TimedDivider = () => {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setTimeout(() => {
      ref.current!.style.display = 'block';
    }, 1500);
  });

  return (
    <Stack.Item>
      <div
        style={{
          borderStyle: 'solid',
          borderWidth: '1px',
          display: 'none',
        }}
        className="dividerEffect"
        ref={ref}
      />
    </Stack.Item>
  );
};

type LobbyButtonProps = BoxProps & {
  readonly index: number;
  readonly selected?: boolean;
  readonly disabled?: boolean;
  readonly icon?: string;
  readonly tooltip?: string;
};

const LobbyButton = (props: LobbyButtonProps) => {
  const { children, index, className, ...rest } = props;

  return (
    <Stack.Item
      className="buttonEffect"
      style={{ animationDelay: `${1.5 + index * 0.2}s` }}
    >
      <Button fluid className={'distinctButton ' + className} {...rest}>
        {children}
      </Button>
    </Stack.Item>
  );
};
