import { PropsWithChildren, useEffect, useRef } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type LobbyData = {
  icon: string;
  lobby_icon: string;
};

export const LobbyMenu = () => {
  const { data } = useBackend<LobbyData>();

  return (
    <Window theme="crtgreen" fitted scrollbars={false}>
      <Window.Content
        className="LobbyScreen"
        style={{
          backgroundPosition: 'center',
          backgroundSize: 'cover',
        }}
        fitted
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
  const { data } = useBackend<LobbyData>();

  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setTimeout(() => {
      ref.current!.style.display = 'block';
    }, 2000);
  });

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
            <Stack.Item width="150px">
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
                          animationDelay: '2.8s',
                        }}
                      >
                        Scotty Bedeell
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>

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

        <LobbyButton index={1}>Tutorial</LobbyButton>
        <LobbyButton index={2}>Setup Character</LobbyButton>
        <LobbyButton index={3}>View Playtimes</LobbyButton>
        <LobbyButton index={4}>View the Crew Manifest</LobbyButton>
        <LobbyButton index={5}>View Hive Leaders</LobbyButton>
        <LobbyButton index={6}>Join the USCM</LobbyButton>
        <LobbyButton index={7}>Join the Hive</LobbyButton>
        <LobbyButton index={8}>Observe</LobbyButton>
      </Stack>
    </Section>
  );
};

interface ButtonProps extends PropsWithChildren {
  readonly index: number;
}

const LobbyButton = (props: ButtonProps) => {
  const { children, index } = props;

  return (
    <Stack.Item
      className="buttonEffect"
      style={{ animationDelay: `${2.5 + index * 0.2}s` }}
    >
      <Button fluid className="distinctButton">
        {children}
      </Button>
    </Stack.Item>
  );
};
