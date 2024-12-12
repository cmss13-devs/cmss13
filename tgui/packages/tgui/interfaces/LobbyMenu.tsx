import { BooleanLike } from 'common/react';
import { storage } from 'common/storage';
import {
  createContext,
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
  Modal,
  Section,
  Stack,
} from '../components';
import { BoxProps } from '../components/Box';
import { Window } from '../layouts';

type LobbyData = {
  lobby_author: string;

  character_name: string;
  display_number: string;

  tutorials_ready: BooleanLike;
  round_start: BooleanLike;
  readied: BooleanLike;

  upp_enabled: BooleanLike;
  xenomorph_enabled: BooleanLike;
  predator_enabled: BooleanLike;
  fax_responder_enabled: BooleanLike;
};

type LobbyContextType = {
  animationsDisable: boolean;
};

const LobbyContext = createContext({ animationsDisable: false });

export const LobbyMenu = () => {
  const { act, data } = useBackend<LobbyData>();

  const { lobby_author } = data;

  const onLoadPlayer = useRef<HTMLAudioElement>(null);

  const [modal, setModal] = useState<ReactNode | false>(false);
  const [disableAnimations, setDisableAnimations] = useState(false);

  const [filterDisabled, setFilterDisabled] = useState(false);

  useEffect(() => {
    storage
      .get('lobby-filter-disabled')
      .then((val) => setFilterDisabled(!!val));

    onLoadPlayer.current!.volume = 0.2;

    setTimeout(() => {
      onLoadPlayer.current!.play();
    }, 250);

    setTimeout(() => {
      setDisableAnimations(true);
    }, 10000);
  }, []);

  return (
    <Window theme="crtgreen" fitted scrollbars={false}>
      <audio src={resolveAsset('load')} ref={onLoadPlayer} />
      <Window.Content
        className={`LobbyScreen ${filterDisabled ? '' : 'filterEnabled'} ${disableAnimations}`}
        style={{
          backgroundPosition: 'center',
          backgroundSize: 'cover',
        }}
        fitted
      >
        <LobbyContext.Provider value={{ animationsDisable: disableAnimations }}>
          {!!modal && (
            <Modal>
              <Section
                buttons={
                  <Button mb={5} onClick={() => setModal(false)} icon={'x'} />
                }
                p={3}
                title={'Confirm'}
              >
                {modal}
              </Section>
            </Modal>
          )}
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
              tooltip={`${filterDisabled ? 'Enable' : 'Disable'} Cinema Mode`}
              onClick={() => {
                storage.set('lobby-filter-disabled', !filterDisabled);
                setFilterDisabled(!filterDisabled);
              }}
            />
          </Box>
          <Stack vertical height="100%" justify="space-around" align="center">
            <Stack.Item>
              <LobbyButtons setModal={setModal} />
            </Stack.Item>
          </Stack>
          <Box className="bgLoad authorAttrib">
            {lobby_author ? `Art by ${lobby_author}` : ''}
          </Box>
        </LobbyContext.Provider>
      </Window.Content>
    </Window>
  );
};

const LobbyButtons = (props: { readonly setModal: (_) => void }) => {
  const { act, data } = useBackend<LobbyData>();

  const { setModal } = props;

  const {
    character_name,
    display_number,
    round_start,
    readied,
    predator_enabled,
    fax_responder_enabled,
    upp_enabled,
    tutorials_ready,
    xenomorph_enabled,
  } = data;

  return (
    <Section
      p={3}
      className="sectionLoad"
      style={{
        boxShadow: '0 0 15px',
        backgroundColor: 'rgba(0, 17, 0, 0.8)',
      }}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Box height="68px">
                <Box
                  style={{
                    backgroundImage: `url("${resolveAsset('uscm.png')}")`,
                  }}
                  width="67px"
                  className="loadEffect"
                />
              </Box>
            </Stack.Item>
            <Stack.Item minWidth="200px">
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

        <LobbyButton
          index={1}
          onClick={() => act('tutorial')}
          disabled={!tutorials_ready}
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
        <LobbyButton index={3} onClick={() => act('playtimes')} icon="list-ul">
          View Playtimes
        </LobbyButton>

        <TimedDivider />

        <LobbyButton
          index={4}
          icon="eye"
          onClick={() => {
            setModal(
              <Box>
                <Stack vertical>
                  <Stack.Item>Are you sure you wish to observe?</Stack.Item>
                  <Stack.Item>
                    When you observe, you will not be able to join as marine.
                  </Stack.Item>
                  <Stack.Item>
                    It might also take some time to become a xeno or responder!
                  </Stack.Item>
                </Stack>
                <Stack justify="center">
                  <Stack.Item>
                    <Button onClick={() => act('observe')}>Confirm</Button>
                  </Stack.Item>
                </Stack>
              </Box>,
            );
          }}
        >
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
                  icon={xenomorph_enabled ? 'virus' : 'check'}
                  color={xenomorph_enabled ? 'purple' : undefined}
                  tooltip={xenomorph_enabled ? 'Ready as Xenomorph' : undefined}
                >
                  Ready
                </LobbyButton>
              </Stack.Item>
              <Stack.Item grow>
                <LobbyButton
                  index={5}
                  disabled={!readied}
                  onClick={() => act('unready')}
                  icon="xmark"
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
                  <LobbyButton
                    index={5}
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
                    index={8}
                    onClick={() => act('manifest')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <LobbyButton
                    index={6}
                    icon="viruses"
                    onClick={() => {
                      setModal(
                        <Box>
                          <Stack vertical>
                            <Stack.Item>
                              Are you sure want to attempt joining as a
                              Xenomorph?
                            </Stack.Item>
                          </Stack>
                          <Stack justify="center">
                            <Stack.Item>
                              <Button onClick={() => act('late_join_xeno')}>
                                Confirm
                              </Button>
                            </Stack.Item>
                          </Stack>
                        </Box>,
                      );
                    }}
                  >
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
                <LobbyButton
                  index={7}
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
                  index={7 + (upp_enabled ? 1 : 0)}
                  icon="skull-crossbones"
                  onClick={() => {
                    setModal(
                      <Box>
                        <Stack vertical>
                          <Stack.Item>
                            Are you sure want to attempt joining as a Predator?
                          </Stack.Item>
                        </Stack>
                        <Stack justify="center">
                          <Stack.Item>
                            <Button onClick={() => act('late_join_pred')}>
                              Confirm
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Box>,
                    );
                  }}
                >
                  Join the Hunt
                </LobbyButton>
              </Stack.Item>
            )}
            {!!fax_responder_enabled && (
              <Stack.Item>
                <LobbyButton
                  index={7 + (upp_enabled ? 1 : 0) + (predator_enabled ? 1 : 0)}
                  icon="fax"
                  onClick={() => {
                    setModal(
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
                      </Box>,
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
        {children}
      </Button>
    </Stack.Item>
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
