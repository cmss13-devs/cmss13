import { useBackend, useSharedState } from '../backend';
import {
  Button,
  Collapsible,
  Divider,
  Input,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

interface SortingProps {
  paper_data: PaperData[] | null;
}

interface PaperData {
  name: string;
  document_id: string;
  completed: boolean;
  overdose: number;
  overall_value: number;
  properties_list: PropertyCode[];
}

interface PropertyCode {
  code: string;
  level: number;
}

export const AutosortingCabinet = () => {
  const { data, act } = useBackend<SortingProps>();
  const [selectedSort, setSelectedSort] = useSharedState('NONE', 0);
  const [selectedOrder, setselectedOrder] = useSharedState('ASCENDING', true);
  const [selectedSearch, setSelectedSearch] = useSharedState('SEARCH', '');
  if (data.paper_data) {
    selectedSort === 1
      ? data.paper_data.sort((a, b) => a.overall_value - b.overall_value)
      : selectedSort === 2
        ? data.paper_data.sort((a, b) => a.overdose - b.overdose)
        : data.paper_data.sort((a, b) => a.overall_value - b.overall_value);
  }
  if (data.paper_data) {
    if (selectedSearch !== '') {
      data.paper_data = data.paper_data.filter(
        (property) =>
          property.properties_list.some(
            (prop) =>
              prop.code
                .toUpperCase()
                .includes(selectedSearch.toUpperCase().replace(/[ ]/g, '')) ||
              prop.level.toString() === selectedSearch ||
              prop.code + prop.level === selectedSearch.replace(/[ ]/g, ''),
          ) ||
          property.name.toUpperCase().includes(selectedSearch.toUpperCase()) ||
          property.overdose.toString() === selectedSearch,
      );
    }
    selectedOrder === true ? data.paper_data.reverse() : data.paper_data;
  } else {
    data.paper_data = null;
  }

  return (
    <Window width={495} height={500} theme="crtblue">
      <Window.Content scrollable>
        <Section>
          <Input
            placeholder="Chemical name, Property code, Level, OD, etc..."
            width={'450px'}
            onInput={(e, value) => setSelectedSearch(value.toUpperCase())}
          />
          <Button
            width={'100px'}
            mx={'1px'}
            ml={'2px'}
            fontSize={'11px'}
            tooltip={
              'Sort by overrall value of the chemical, including its OD level, properties and levels on it.'
            }
            selected={selectedSort === 1}
            onClick={() => setSelectedSort(1)}
          >
            Sort by Value
          </Button>
          <Button
            width={'100px'}
            my={1}
            mx={'1px'}
            fontSize={'11px'}
            tooltip={'Sort by OD level of documents.'}
            selected={selectedSort === 2}
            onClick={() => setSelectedSort(2)}
          >
            Sort by OD
          </Button>
          <Button
            width={'100px'}
            my={1}
            mx={'1px'}
            mr={'1px'}
            fontSize={'11px'}
            tooltip={'Sort by types of papers: Contracts, Scans, Etc...'}
            selected={selectedSort === 3}
            onClick={() => setSelectedSort(3)}
          >
            Sort by Class
          </Button>
          <Button
            fontSize={'11px'}
            icon={'check'}
            ml={'1px'}
            width={5.8}
            iconPosition="right"
            tooltip={'Only Include chemicals that can be used in the simulator'}
            tooltipPosition="bottom"
            preserveWhitespace
          >
            {'   '}
          </Button>
          <Button
            fontSize={'11px'}
            icon={'arrows-up-down'}
            ml={'1px'}
            width={5.8}
            iconPosition="right"
            tooltip={'Switch between Ascending and Descending'}
            tooltipPosition="bottom"
            preserveWhitespace
            selected={selectedOrder}
            onClick={() => setselectedOrder(!selectedOrder)}
          >
            {'   '}
          </Button>
          <Divider />
          {data.paper_data === null ? (
            <NoticeBox info>Cabinet is empty!</NoticeBox>
          ) : (
            data.paper_data.map((x, b) => (
              <Collapsible
                key={x.name}
                title={
                  <>
                    {x.name}{' '}
                    {x.properties_list
                      .map((prop) => prop.code + prop.level)
                      .join(', ')}
                    {}
                  </>
                }
                buttons={
                  <Button
                    width={2}
                    height
                    tooltip={'Take out the document from sorting array.'}
                    icon={'print'}
                    onClick={() =>
                      act('take_out_document', { document_id: x.document_id })
                    }
                  />
                }
              >
                Overdose: {x.overdose} <br />
                Total Value: {x.overall_value}
              </Collapsible>
            ))
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
