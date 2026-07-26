import { useState } from 'react';

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
  overdose: number;
  overall_value: number;
  document_type: number;
  properties_list: PropertyCode[];
}

interface PropertyCode {
  code: string;
  level: number;
  shouldHighlight: boolean;
}

export const AutosortingCabinet = () => {
  const { data, act } = useBackend<SortingProps>();
  const [selectedSort, setSelectedSort] = useSharedState('NONE', 0);
  const [selectedOrder, setselectedOrder] = useSharedState('ASCENDING', true);
  let paperDocumentFinal: PaperData[] | null = data.paper_data;
  const [selectedSearch, setSelectedSearch] = useState('');
  if (paperDocumentFinal) {
    selectedSort === 1
      ? paperDocumentFinal.sort((a, b) => a.overall_value - b.overall_value)
      : selectedSort === 2
        ? paperDocumentFinal.sort((a, b) => a.overdose - b.overdose)
        : paperDocumentFinal.sort((a, b) => a.document_type - b.document_type);
  }
  if (paperDocumentFinal) {
    if (selectedSearch !== '') {
      paperDocumentFinal = paperDocumentFinal.filter(
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
    selectedOrder === true &&
    paperDocumentFinal !== paperDocumentFinal.toReversed()
      ? (paperDocumentFinal = paperDocumentFinal.toReversed())
      : paperDocumentFinal;
    for (let idoc = 0; idoc < paperDocumentFinal?.length; idoc++) {
      for (
        let iprop = 0;
        iprop < paperDocumentFinal[idoc].properties_list.length;
        iprop++
      ) {
        if (
          (paperDocumentFinal[idoc].properties_list[iprop].code
            .toUpperCase()
            .includes(selectedSearch.toUpperCase().replace(/[ ]/g, '')) ||
            paperDocumentFinal[idoc].properties_list[iprop].level.toString() ===
              selectedSearch ||
            paperDocumentFinal[idoc].properties_list[iprop].code +
              paperDocumentFinal[idoc].properties_list[iprop].level ===
              selectedSearch.replace(/[ ]/g, '')) &&
          (selectedSearch.length >= 3 || !isNaN(parseFloat(selectedSearch)))
        ) {
          paperDocumentFinal[idoc].properties_list[iprop].shouldHighlight =
            true;
        } else {
          paperDocumentFinal[idoc].properties_list[iprop].shouldHighlight =
            false;
        }
      }
    }
  } else {
    paperDocumentFinal = null;
  }

  return (
    <Window width={495} height={500} theme="crtblue">
      <Window.Content scrollable>
        <Section>
          <Input
            placeholder="Chemical name, Property code, Level, OD, etc..."
            width={'450px'}
            onEscape={(e) => setSelectedSearch('')}
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
          {paperDocumentFinal === null ? (
            <NoticeBox info>Cabinet is empty!</NoticeBox>
          ) : (
            paperDocumentFinal.map((x, b) => (
              <Collapsible
                key={x.name}
                title={
                  <>
                    {x.name}{' '}
                    {x.properties_list.map((prop, id) => (
                      <div
                        key={id}
                        style={{
                          whiteSpace: 'pre',
                          display: 'inline-flex',
                        }}
                      >
                        <div
                          style={{
                            backgroundColor:
                              prop.shouldHighlight === true
                                ? 'yellow'
                                : undefined,
                          }}
                        >
                          {prop.code}
                          {prop.level}
                        </div>
                        <div>, </div>
                      </div>
                    ))}
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
