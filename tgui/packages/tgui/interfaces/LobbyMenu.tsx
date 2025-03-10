import { randomInteger } from 'common/random';
import { BooleanLike, classes } from 'common/react';
import { storage } from 'common/storage';
import {
  createContext,
  PropsWithChildren,
  ReactNode,
  useContext,
  useEffect,
  useRef,
  useState,
} from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  Box,
  Button as NativeButton,
  Flex,
  Modal,
  Section,
  Stack,
} from '../components';
import { BoxProps } from '../components/Box';
import { Window } from '../layouts';
import { LoadingScreen } from './common/LoadingToolbox';

type LobbyData = {
  lobby_author: string;

  character_name: string;
  xeno_prefix: string;
  xeno_postfix: string;

  tutorials_ready: BooleanLike;
  round_start: BooleanLike;
  readied: BooleanLike;

  confirmation_message?: string | string[];

  upp_enabled: BooleanLike;
  xenomorph_enabled: BooleanLike;
  predator_enabled: BooleanLike;
  fax_responder_enabled: BooleanLike;

  preference_issues: string[];
};

type LobbyContextType = {
  animationsDisable: boolean;
  themeDisable: boolean;
  setModal?: (_: ReactNode | false) => void;
};

const LobbyContext = createContext<LobbyContextType>({
  animationsDisable: false,
  themeDisable: false,
});

export const LobbyMenu = () => {
  const { act, data } = useBackend<LobbyData>();

  const { lobby_author, upp_enabled, confirmation_message, preference_issues } =
    data;

  const onLoadPlayer = useRef<HTMLAudioElement>(null);

  const [modal, setModal] = useState<ReactNode | false>(false);

  const [disableAnimations, setDisableAnimations] = useState(false);
  const [filterDisabled, setFilterDisabled] = useState(false);
  const [themeDisabled, setThemeDisabled] = useState<boolean | undefined>();

  useEffect(() => {
    storage
      .get('lobby-filter-disabled')
      .then((val) => setFilterDisabled(!!val));

    storage.get('lobby-theme-disabled').then((val) => setThemeDisabled(!!val));

    setTimeout(() => {
      onLoadPlayer.current!.play();
    }, 250);

    setTimeout(() => {
      setDisableAnimations(true);
    }, 10000);
  }, []);

  useEffect(() => {
    if (!confirmation_message) return;

    setModal(
      <Section
        buttons={
          <Button
            mb={5}
            onClick={() => {
              setModal!(false);
              act('unconfirm');
            }}
            icon={'x'}
          />
        }
        p={3}
        title={'Confirm'}
      >
        <Box>
          <Stack vertical>
            {Array.isArray(confirmation_message) ? (
              confirmation_message.map((element, index) => (
                <Stack.Item key={index}>{element}</Stack.Item>
              ))
            ) : (
              <Stack.Item>{confirmation_message}</Stack.Item>
            )}
          </Stack>
          <Stack justify="center">
            <Stack.Item>
              <Button onClick={() => act('confirm')}>Confirm</Button>
            </Stack.Item>
          </Stack>
        </Box>
      </Section>,
    );
  }, [confirmation_message]);

  const [hidden, setHidden] = useState<boolean>(false);

  if (themeDisabled === undefined) {
    return (
      <Window fitted scrollbars={false}>
        <Window.Content>
          <LoadingScreen />
        </Window.Content>
      </Window>
    );
  }

  const themeToUse = themeDisabled
    ? 'weyland_yutani'
    : upp_enabled
      ? 'crtlobbyred'
      : 'crtlobby';

  return (
    <Window theme={themeToUse} fitted scrollbars={false}>
      <audio src={resolveAsset('load.mp3')} ref={onLoadPlayer} />
      <Window.Content
        className={classes([
          'LobbyScreen',
          !themeDisabled && 'crtTheme',
          !filterDisabled && 'filterEnabled',
          disableAnimations,
        ])}
        fitted
      >
        <LobbyContext.Provider
          value={{
            animationsDisable: disableAnimations,
            themeDisable: themeDisabled,
            setModal: setModal,
          }}
        >
          {!!modal && <Modal>{modal}</Modal>}
          <Box
            height="100%"
            width="100%"
            style={{
              backgroundImage: `url(${resolveAsset('lobby_art.png')})`,
            }}
            className="bgLoad bgBackground"
          />
          <Box height="100%" width="100%" position="absolute" className="crt" />
          <Box position="absolute" top="10px" right="10px">
            <Button
              icon="cog"
              onClick={() => {
                setModal(
                  <Box className="styledText">
                    <Section
                      p={5}
                      title="Lobby Settings"
                      buttons={
                        <Button icon="xmark" onClick={() => setModal(false)} />
                      }
                      className="styledText"
                    >
                      <Stack>
                        <Stack.Item>
                          <Button
                            icon="tv"
                            onClick={() => {
                              storage.set(
                                'lobby-filter-disabled',
                                !filterDisabled,
                              );
                              setFilterDisabled(!filterDisabled);
                              setModal(false);
                            }}
                            tooltip="Removes the CRT filter background"
                          >
                            {`${filterDisabled ? 'Enable' : 'Disable'} Cinema Mode`}
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="bolt"
                            onClick={() => {
                              storage.set(
                                'lobby-theme-disabled',
                                !themeDisabled,
                              );
                              setThemeDisabled(!themeDisabled);
                              setModal(false);
                            }}
                            tooltip="Totally removes the CRT theme, including the filter"
                          >
                            {`${themeDisabled ? 'Enable' : 'Disable'} CRT Theme`}
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Section>
                  </Box>,
                );
              }}
            />
          </Box>
          {hidden && (
            <Box position="absolute" top="10px" left="10px">
              <Button icon={'check'} onClick={() => setHidden(false)} />
            </Box>
          )}
          <Stack vertical height="100%" justify="space-around" align="center">
            <Stack.Item>
              <LobbyButtons
                setModal={setModal}
                hidden={hidden}
                setHidden={setHidden}
              />
            </Stack.Item>
          </Stack>
          <Box className="bgLoad authorAttrib styledText">
            {lobby_author ? `Art by ${lobby_author}` : ''}
          </Box>
          <Box
            position="absolute"
            left={3}
            top={-2}
            height="100%"
            className="messageHolder"
          >
            <Stack vertical justify="flex-end" fill>
              {preference_issues.map((issue, index) => (
                <Section key={index} className="sectionLoad">
                  <Box>{issue}</Box>
                </Section>
              ))}
            </Stack>
          </Box>
        </LobbyContext.Provider>
      </Window.Content>
    </Window>
  );
};

const ModalConfirm = (props: PropsWithChildren) => {
  const { children } = props;

  const context = useContext(LobbyContext);

  const { setModal } = context;

  return (
    <Section
      buttons={<Button mb={5} onClick={() => setModal!(false)} icon={'x'} />}
      p={3}
      title={'Confirm'}
    >
      {children}
    </Section>
  );
};

const SMALL_BUTTON_DELAY = 3;

const LobbyButtons = (props: {
  readonly setModal: (_) => void;
  readonly hidden: boolean;
  readonly setHidden: (_: boolean) => void;
}) => {
  const { act, data } = useBackend<LobbyData>();

  const { setModal, hidden, setHidden } = props;

  const {
    character_name,
    xeno_postfix,
    xeno_prefix,
    round_start,
    readied,
    predator_enabled,
    fax_responder_enabled,
    upp_enabled,
    tutorials_ready,
    xenomorph_enabled,
  } = data;

  const [xenoNumber] = useState(`${randomInteger(0, 999)}`);

  return (
    <Section
      p={3}
      className="sectionLoad"
      style={{
        opacity: hidden ? '0' : '1',
      }}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Stack vertical justify="space-around" height="100%">
                <Stack.Item>
                  <Box height="68px">
                    <Box
                      style={{
                        backgroundImage: `url("${resolveAsset(upp_enabled ? 'upp.png' : 'uscm.png')}")`,
                      }}
                      width="67px"
                      className="loadEffect"
                      onClick={() => {
                        setHidden(true);
                      }}
                    />
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item minWidth="200px">
              <Stack vertical>
                <Stack.Item>
                  <Stack justify="center">
                    <Stack.Item>
                      <Box className="typeEffect styledText">Welcome,</Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack justify="center">
                    <Stack.Item>
                      <Box
                        className="typeEffect styledText"
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
                        className="typeEffect styledText"
                        style={{
                          animationDelay: '1.4s',
                        }}
                      >
                        {`${xeno_prefix}-${xenoNumber}${xeno_postfix}`}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <TimedDivider />

        <LobbyButton
          index={1}
          onClick={() => act('tutorial')}
          disabled={!tutorials_ready}
          tooltip={
            !tutorials_ready
              ? 'Tutorials can only be started after the game is running.'
              : ''
          }
          icon="book-open"
        >
          Tutorial
        </LobbyButton>
        <LobbyButton
          index={2}
          onClick={() => act('preferences')}
          icon="file-lines"
        >
          Setup Character
        </LobbyButton>

        <LobbyButton index={3} icon="check-to-slot" onClick={() => act('poll')}>
          Polls
        </LobbyButton>

        <LobbyButton index={4} onClick={() => act('playtimes')} icon="list-ul">
          View Playtimes
        </LobbyButton>

        <TimedDivider />

        <LobbyButton
          index={5}
          icon="eye"
          onClick={() => {
            setModal(
              <ModalConfirm>
                <Box>
                  <Stack vertical>
                    <Stack.Item>Are you sure you wish to observe?</Stack.Item>
                    <Stack.Item>
                      When you observe, you will not be able to join as marine.
                    </Stack.Item>
                    <Stack.Item>
                      It might also take some time to become a xeno or
                      responder!
                    </Stack.Item>
                  </Stack>
                  <Stack justify="center">
                    <Stack.Item>
                      <Button onClick={() => act('observe')}>Confirm</Button>
                    </Stack.Item>
                  </Stack>
                </Box>
              </ModalConfirm>,
            );
          }}
        >
          Observe
        </LobbyButton>

        {round_start ? (
          <Stack.Item>
            <LobbyButton
              index={6}
              selected={!!readied}
              onClick={() => act(readied ? 'unready' : 'ready')}
              icon={readied ? 'check' : 'xmark'}
              tooltip={
                xenomorph_enabled ? 'Ready with Xenomorph enabled' : undefined
              }
            >
              {readied ? 'Unready' : 'Ready'}
            </LobbyButton>
          </Stack.Item>
        ) : (
          <>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <LobbyButton
                    index={6}
                    onClick={() => act('late_join')}
                    icon="users"
                  >
                    Join the USCM
                  </LobbyButton>
                </Stack.Item>
                <Stack.Item>
                  <LobbyButton
                    icon="list"
                    tooltip="View Crew Manifest"
                    index={6 + SMALL_BUTTON_DELAY}
                    onClick={() => act('manifest')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <LobbyButton
                    index={7}
                    icon="viruses"
                    onClick={() => act('late_join_xeno')}
                  >
                    Join the Hive
                  </LobbyButton>
                </Stack.Item>
                <Stack.Item>
                  <LobbyButton
                    icon="users-rays"
                    tooltip="View Hive Leaders"
                    index={7 + SMALL_BUTTON_DELAY}
                    onClick={() => act('hiveleaders')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {!!upp_enabled && (
              <Stack.Item>
                <LobbyButton
                  index={8}
                  onClick={() => act('late_join_upp')}
                  icon="users-between-lines"
                >
                  Join the UPP
                </LobbyButton>
              </Stack.Item>
            )}
            {!!predator_enabled && (
              <Stack.Item>
                <LobbyButton
                  index={8 + (upp_enabled ? 1 : 0)}
                  onClick={() => {
                    setModal(
                      <ModalConfirm>
                        <Box>
                          <Stack vertical>
                            <Stack.Item>
                              Are you sure want to attempt joining as a
                              Predator?
                            </Stack.Item>
                          </Stack>
                          <Stack justify="center">
                            <Stack.Item>
                              <Button onClick={() => act('late_join_pred')}>
                                Confirm
                              </Button>
                            </Stack.Item>
                          </Stack>
                        </Box>
                      </ModalConfirm>,
                    );
                  }}
                >
                  <Flex>
                    <Flex.Item>
                      <Box className="pred" inline />
                    </Flex.Item>
                    <Flex.Item>Join the Hunt</Flex.Item>
                  </Flex>
                </LobbyButton>
              </Stack.Item>
            )}
            {!!fax_responder_enabled && (
              <Stack.Item>
                <LobbyButton
                  index={9 + (upp_enabled ? 1 : 0) + (predator_enabled ? 1 : 0)}
                  icon="fax"
                  onClick={() => {
                    setModal(
                      <ModalConfirm>
                        <Box>
                          <Stack vertical>
                            <Stack.Item>
                              Are you sure want to attempt joining as a Fax
                              Responder?
                            </Stack.Item>
                          </Stack>
                          <Stack justify="center">
                            <Stack.Item>
                              <Button onClick={() => act('late_join_faxes')}>
                                Confirm
                              </Button>
                            </Stack.Item>
                          </Stack>
                        </Box>
                      </ModalConfirm>,
                    );
                  }}
                >
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

  const context = useContext(LobbyContext);

  const { themeDisable } = context;

  useEffect(() => {
    if (!themeDisable) {
      setTimeout(() => {
        ref.current!.style.display = 'block';
      }, 1500);
    }
  }, [themeDisable]);

  return (
    <Stack.Item>
      <div
        style={{
          borderStyle: 'solid',
          borderWidth: '1px',
          display: themeDisable ? 'block' : 'none',
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

  const context = useContext<LobbyContextType>(LobbyContext);

  return (
    <Stack.Item
      className="buttonEffect"
      style={{
        animationDelay: context.animationsDisable
          ? '0s'
          : `${1.5 + index * 0.2}s`,
      }}
    >
      <Button fluid className={'distinctButton ' + className} {...rest}>
        <StyledText>{children}</StyledText>
      </Button>
    </Stack.Item>
  );
};

const StyledText = (props: PropsWithChildren) => {
  const { children } = props;

  return (
    <Box inline className="styledText">
      {children}
    </Box>
  );
};

const Button = (props) => {
  const { act } = useBackend();

  return (
    <Box onClick={() => act('keyboard')}>
      <NativeButton {...props} />
    </Box>
  );
};
