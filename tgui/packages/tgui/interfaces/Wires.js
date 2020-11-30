import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, NoticeBox } from '../components';
import { Window } from '../layouts';

export const Wires = (props, context) => {
  const { act, data } = useBackend(context);
  const { proper_name } = data;
  const wires = data.wires || [];
  return (
    <Window
      width={380}
      height={50
        + (wires.length * 30)
        + (!!proper_name && 30)}>
      <Window.Content>
        {(!!proper_name && (
          <NoticeBox textAlign="center">
            {proper_name} Wire Configuration
          </NoticeBox>
        ))}
        <Section>
          <LabeledList>
            {wires.map(wire => (
              <LabeledList.Item
                key={wire.number}
                className="candystripe"
                label={data.wire_descs[wire.number-1]}
                buttons={(
                  <Fragment>
                    <Button
                      width="60px"
                      color={wire.cut ? 'green' : 'red'}
                      content={wire.cut ? 'Mend' : 'Cut'}
                      icon={wire.cut ? 'link' : 'cut'}
                      onClick={() => act('cut', {
                        wire: wire.number,
                      })} />
                    <Button
                      content="Pulse"
                      icon="wave-square"
                      onClick={() => act('pulse', {
                        wire: wire.number,
                      })} />
                    <Button
                      content={wire.attached ? 'Detach' : 'Attach'}
                      icon="paperclip"
                      onClick={() => act('attach', {
                        wire: wire.number,
                      })} />
                  </Fragment>
                )}>
                {!!wire.wire && (
                  <i>
                    ({wire.wire})
                  </i>
                )}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
