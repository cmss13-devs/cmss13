import { useBackend } from '../backend';
import { Button, Icon, ProgressBar, Stack, Tooltip } from '../components';
import { Window } from '../layouts';

interface PortableVendorProduct {
  index: number;
  name: string;
  cost: number;
  color: string;
  description: string;
  available: boolean;
}

interface PortableVendorProps {
  show_points: boolean;
  current_points: number;
  max_points: number;
  displayed_records: PortableVendorProduct[];
  name: string;
}

interface RecordEntryProps {
  readonly record: PortableVendorProduct;
}

const PointCounter = (props) => {
  const { act, data } = useBackend<PortableVendorProps>();

  return (
    <Stack.Item>
      <ProgressBar maxValue={data.max_points} value={data.current_points}>
        {data.current_points} points
      </ProgressBar>
    </Stack.Item>
  );
};

const RecordEntry = (props: RecordEntryProps) => {
  const { act, data } = useBackend<PortableVendorProps>();
  const { record } = props;

  if (!record.description) {
    return <Stack.Item>{record.name}</Stack.Item>;
  }

  return (
    <Stack>
      <Stack.Item>
        <Button onClick={() => act('vend', { choice: record.index })}>
          {record.name}
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Tooltip content={record.description}>
          <Icon name="circle-info" />
        </Tooltip>
      </Stack.Item>
    </Stack>
  );
};

export const PortableVendor = (props) => {
  const { act, data } = useBackend<PortableVendorProps>();

  return (
    <Window width={400} height={700}>
      <Window.Content>
        <Stack vertical>
          {data.show_points && <PointCounter />}
          {data.displayed_records.map((record) => {
            return (
              <Stack.Item key={record.index}>
                <RecordEntry record={record} />
              </Stack.Item>
            );
          })}
        </Stack>
      </Window.Content>
    </Window>
  );
};
