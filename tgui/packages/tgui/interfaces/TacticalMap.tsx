import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';
import { CanvasLayer } from './CanvasLayer';

// byondUI map ref was removed for testing purposes, could be added as a separate tab.
interface TacMapProps {
  // mapRef: string;
  toolbarSelection: string;
  imageSrc: string;
  exportedTacMapImage: any;
}

export const TacticalMap = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);

  // maybe this is the right way of doing this, maybe not, idk.
  const handleTacMapExport = (image: any) => {
    data.exportedTacMapImage = image;
  };

  return (
    <Window title={'Tactical Map'} theme="usmc" width={650} height={750}>
      <Window.Content>
        <Section>
          <CanvasLayer
            selection={data.toolbarSelection}
            imageSrc={data.imageSrc}
            onImageExport={handleTacMapExport}
          />
        </Section>
        <Section title="Canvas Options">
          <Stack>
            <Stack.Item grow>
              <Button // we should add some icon here maybe, someone redo the ui plz; it's shit.
                fontSize="9px"
                fluid={1}
                color="grey"
                content="Announce"
                className="text-center"
                onClick={() =>
                  act('selectAnnouncement', { image: data.exportedTacMapImage })
                }
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="7px"
                fluid={1}
                icon="trash"
                color="grey"
                content="Clear Canvas"
                className="text-center"
                onClick={() => act('clearCanvas')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="10px"
                fluid={1}
                icon="recycle"
                color="grey"
                content="Undo"
                className="text-center"
                onClick={() => act('undoChange')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="12px"
                fluid={1}
                color="red"
                content="Red"
                className="text-center"
                onClick={() => act('selectRed')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="12px"
                fluid={1}
                color="orange"
                content="Orange"
                className="text-center"
                onClick={() => act('selectOrange')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="12px"
                fluid={1}
                color="blue"
                content="Blue"
                className="text-center"
                onClick={() => act('selectBlue')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="12px"
                fluid={1}
                color="purple"
                content="Purple"
                className="text-center"
                onClick={() => act('selectPurple')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="12px"
                fluid={1}
                color="good"
                content="Green"
                className="text-center"
                onClick={() => act('selectGreen')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
