import { useBackend } from '../backend';
import { Box, LabeledList, Table } from '../components';
import { Window } from '../layouts';

type SupplyManifestData = {
  ordername: string;
  shipname: string;
  ordernum: string;
  orderedby: string;
  orderedby_rank: string;
  approvedby: string;
  approvedby_rank: string;
  reason: string;
  date: string;
  accesses: string[];
  stampslist: StampsList[];
  packages: string[];
};

type StampsList = {
  name: string;
  position: StampPosition;
  rotation: string;
};

type StampPosition = {
  x: number;
  y: number;
};

export type StampAreaProps = {
  readonly stampslist?: StampsList[]; // Опциональный массив штампов
};

export const PaperSupplyManifest = () => {
  const { data } = useBackend<SupplyManifestData>();

  const STAMP_TYPES = {
    'stamp-approve': {
      text: 'ОДОБРЕНО',
      color: '#246700',
    },
    'stamp-deny': {
      text: 'ОТКАЗАНО',
      color: '#a13e3e',
    },
    default: {
      text: 'УТВЕРЖДЕНО',
      color: '#4f3c08',
    },
  };

  const StampArea = ({ stampslist = [] }: StampAreaProps) => {
    if (!stampslist || !Array.isArray(stampslist)) {
      return null;
    }

    return (
      <>
        {stampslist.map((item: StampsList, index) => {
          const stamp = STAMP_TYPES[item.name] || STAMP_TYPES['default'];
          const xPos = item.position?.x || 0;
          const yPos = item.position?.y || 0;
          const rotation = item.rotation || 0;

          return (
            <Box
              key={`stamp-${index}`}
              style={{
                position: 'absolute',
                left: `calc(${xPos}% - 90px)`,
                top: `${yPos}%`,
                width: '180px',
                height: '50px',
                border: `4px solid ${stamp.color ?? '#ccc'}`,
                borderRadius: '3px',
                color: stamp.color ?? '#ccc',
                fontWeight: 'bold',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                transform: `rotate(${rotation}deg)`,
                fontSize: '18px',
                zIndex: `${index}`,
              }}
            >
              {stamp.text}
            </Box>
          );
        })}
      </>
    );
  };

  const renderPacks = (packages: string[]) => {
    return packages.map((item, index) => (
      <Table.Row key={index}>
        <Table.Cell>• {item}</Table.Cell>
      </Table.Row>
    ));
  };

  return (
    <Window width={600} height={800} theme="paper">
      <Window.Content scrollable>
        <Box
          style={{
            backgroundColor: '#fff',
            border: '2px solid #1a3c6e',
            borderRadius: '3px',
            height: '100%',
            padding: '25px',
            boxShadow: '0 0 10px rgba(0, 0, 0, 0.1)',
          }}
        >
          <Box
            mb="20px"
            style={{
              textAlign: 'center',
              borderBottom: '1px solid #1a3c6e',
              paddingBottom: '15px',
            }}
          >
            <Box
              mb="5px"
              style={{
                fontSize: '28px',
                letterSpacing: '5px',
                fontWeight: 'bold',
                color: '#1a3c6e',
              }}
            >
              A.S.R.S.
            </Box>
            <Box
              mb="15px"
              style={{
                fontSize: '18px',
                fontWeight: 'bold',
                color: '#555',
              }}
            >
              Автоматизированные складские системы
            </Box>
            <Box
              inline
              px="10px"
              py="3px"
              style={{
                borderRadius: '3px',
                marginBottom: '10px',
                backgroundColor: '#1a3c6e',
                color: 'white',
                fontWeight: 'bold',
              }}
            >
              Груз #ASRS-{data.ordernum}
            </Box>
          </Box>
          <Box mb="20px">
            <LabeledList>
              <LabeledList.Item label="Груз">{data.ordername}</LabeledList.Item>
              <LabeledList.Item label="Заказчик">
                {data.orderedby}, {data.orderedby_rank}
              </LabeledList.Item>
              <LabeledList.Item label="Одобрил">
                {data.approvedby
                  ? `${data.approvedby}, ${data.approvedby_rank ?? ''}`
                  : 'Не указано'}
              </LabeledList.Item>
              <LabeledList.Item label="Объём">
                {data.packages.length ?? '0'}
              </LabeledList.Item>
              <LabeledList.Item label="Дата и место">
                {data.date}, {data.shipname}
              </LabeledList.Item>
            </LabeledList>
          </Box>
          <Box mb="20px">
            <Box textAlign="center" fontWeight="bold" mb="10px">
              ОПИСЬ ГРУЗА
            </Box>
            <Table>{renderPacks(data.packages)}</Table>
          </Box>
          <Box
            style={{
              borderTop: '1px dashed #1a3c6e',
              paddingTop: '15px',
              textAlign: 'center',
              marginTop: '30px',
              fontWeight: 'bold',
            }}
          >
            Пожалуйста, поставьте печать и верните отправителю, чтобы
            подтвердить получение
            <Box
              style={{
                position: 'relative',
                width: '100%',
                minHeight: '80px',
                border: '1px dashed #999',
                marginTop: '15px',
              }}
            >
              <Box
                style={{
                  display: 'flex',
                  height: '100%',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#777',
                  position: 'relative',
                  paddingTop: '30px',
                }}
              >
                [МЕСТО ДЛЯ ПЕЧАТИ]
              </Box>
              <StampArea stampslist={data.stampslist || []} />
            </Box>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};
