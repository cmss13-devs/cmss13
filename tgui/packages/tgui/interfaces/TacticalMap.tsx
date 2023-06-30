import { useBackend } from '../backend';
import { Button, Dropdown, Section, Stack, ProgressBar, Box} from '../components';
import { Window } from '../layouts';
import { CanvasLayer } from './CanvasLayer';

interface TacMapProps {
  toolbarColorSelection: string;
  toolbarUpdatedSelection: string;
  updatedCanvas: boolean;
  imageSrc: string;
  worldtime: any;
  nextcanvastime: any;
  canvas_cooldown: any;
  exportedTacMapImage: any;
}

export const TacticalMap = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);

  const timeLeft = data.nextcanvastime - data.worldtime;

  const timeLeftPct = timeLeft / data.canvas_cooldown;

  const canUpdate = timeLeft < 0 && !data.updatedCanvas;

  const handleTacMapExport = (image: any) => {
    data.exportedTacMapImage = image;
  };

  const colorOptions = [
    'black',
    'red',
    'orange',
    'blue',
    'purple',
    'green'
  ];

  return (
    <Window title={'Tactical Map'} theme="usmc" width={650} height={750}>
      <Window.Content>
        <Section>
          <CanvasLayer
            selection={data.toolbarUpdatedSelection}
            imageSrc={data.imageSrc}
            onImageExport={handleTacMapExport}
          />
        </Section>
        <Section title="Canvas Options">
          <Stack>
            <Stack.Item grow>
            {(!data.updatedCanvas && (
                <Button
                  fontSize="10px"
                  fluid={1}
                  disabled={!canUpdate}
                  color="red"
                  content="Update Canvas"
                  onClick={() => act('updateCanvas')}
                />
              )) || (
                <Button
                  fontSize="10px"
                  fluid={1}
                  color="green"
                  icon="checkmark"
                  content="Announce"
                  className="text-center"
                  onClick={() =>
                  act('selectAnnouncement', { image: data.exportedTacMapImage })
                }
              />
              )}
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="10px"
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
              <Dropdown
                fluid={1}
                options={colorOptions}
                selected={data.toolbarColorSelection}
                color={data.toolbarColorSelection}
                onSelected={(value) => act('selectColor', { color: value })}
              />
            </Stack.Item>
          </Stack>
          <Stack>
          <Stack.Item grow>
            {timeLeft > 0 && (
              <ProgressBar
                  value={timeLeftPct}
                  ranges={{
                    good: [-Infinity, 0.33],
                    average: [0.33, 0.67],
                    bad: [0.67, Infinity],
                    }}>
                  <Box textAlign="center" fontSize="15px">
                    {Math.ceil(timeLeft / 10)} seconds until the canvas changes can be updated
                  </Box>
            </ProgressBar>
          )}
          </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

