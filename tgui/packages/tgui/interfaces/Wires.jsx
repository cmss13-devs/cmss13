import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const Wires = (props) => {
  const { act, data } = useBackend();
  const { proper_name } = data;
  const wires = data.wires || [];
  return (
    <Window width={380} height={50 + wires.length * 30 + (!!proper_name && 30)}>
      <Window.Content>
        {!!proper_name && (
          <NoticeBox textAlign="center">
            {proper_name} Wire Configuration
          </NoticeBox>
        )}
        <Section>
          <LabeledList>
            {wires.map((wire) => (
              <LabeledList.Item
                key={wire.number}
                className="candystripe"
                label={data.wire_descs[wire.number - 1]}
                buttons={
                  <>
                    <Button
                      width="60px"
                      color={wire.cut ? 'green' : 'red'}
                      icon={wire.cut ? 'link' : 'cut'}
                      onClick={() =>
                        act('cut', {
                          wire: wire.number,
                        })
                      }
                    >
                      {wire.cut ? 'Mend' : 'Cut'}
                    </Button>
                    <Button
                      icon="wave-square"
                      onClick={() =>
                        act('pulse', {
                          wire: wire.number,
                        })
                      }
                    >
                      Pulse
                    </Button>
                    <Button
                      icon="paperclip"
                      onClick={() =>
                        act('attach', {
                          wire: wire.number,
                        })
                      }
                    >
                      {wire.attached ? 'Detach' : 'Attach'}
                    </Button>
                  </>
                }
              >
                {!!wire.wire && <i>({wire.wire})</i>}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
