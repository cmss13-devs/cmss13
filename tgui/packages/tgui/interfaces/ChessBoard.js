import { useBackend } from '../backend';
import { Button, Section, Flex, Table } from '../components';
import { Window } from '../layouts';

const row = [0, 1, 2, 3, 4, 5, 6, 7];

export const ChessBoard = (props, context) => {
  return (
    <Window width={720} height={950}>
      <Window.Content scrollable>
        <WhiteChessPieces />
        <ChessBoardContent />
        <BlackChessPieces />
        <Testing />
      </Window.Content>
    </Window>
  );
};

const ChessPieceBackgroundColor = "gray";

// Generate White Pieces
const WhiteChessPieces = (props, context) => {

  const { act, data } = useBackend(context);
  const {
    white_chess_pieces,
  } = data;
  return (
    <Section title="White Chess Pieces">
      <Flex wrap="wrap" align="center" justify="space-evenly">
        {white_chess_pieces.map((piece, index) => (
          <Flex.Item key={index}>
            <Button
            backgroundColor={ChessPieceBackgroundColor}
            textColor="white"
            m={"2px"}
            content={piece.color + " " + piece.name}
            icon={"fa-solid fa-chess-" + piece.name} />
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

// Generate Black Pieces
const BlackChessPieces = (props, context) => {

  const { act, data } = useBackend(context);
  const {
    black_chess_pieces,
  } = data;
  return (
    <Section title="Black Chess Pieces">
      <Flex wrap="wrap" align="center" justify="space-evenly">
        {black_chess_pieces.map((piece, index) => (
          <Flex.Item key={index}>
            <Button
            textAlign={"center"}
            verticalAlignContent={"middle"}
            backgroundColor={ChessPieceBackgroundColor}
            textColor="black"
            m={"2px"}
            content={piece.color + " " + piece.name}
            icon={"fa-solid fa-chess-" + piece.name} />
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const GenerateRows = () => {
  const rows = [];
  for(let x = 0; x < 8; x++) {
    const row = [];
    const order = x % 2 === 1 ? 0 : 1;
    for(let y = 0; y < 8; y++) {
      row.push(GenerateCell(y + order));
    }
    rows.push(<Table.Row>{row}</Table.Row>);
  }
  return <Table> { rows } </Table>;
};

const GenerateCell = (index) => {
  const color = index % 2 === 1 ? "#564424" : "#ad9264";
  return (
  <Table.Cell
  backgroundColor={color}
  height={"8vh"}
  width={"8vw"}>
    <Button fluid
    backgroundColor={"transparent"} // Red for Testing and Transparent on Use
    height={"100%"}
    width={"100%"}
    textColor="rgba(0, 0, 0, 0)"
    color="transparent"
    onClick={() => act('test')} />
  </Table.Cell>);
};

const ChessBoardContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    health,
    color,
  } = data;
  // Front End
  return (
    <Section title="Chess Board">
      {GenerateRows()}
    </Section>
  );
};

const Testing = () => {
  return (
    <Table>
      <Table.Row>
        <Table.Cell>
          <Button fluid preserveWhitespace
          m={"0%"}
          content={"TESTING"}
          backgroundColor={"red"} />
        </Table.Cell>
        <Table.Cell>
          <Button fluid preserveWhitespace
          m={"0%"}
          content={"TESTING"}
          backgroundColor={"red"} />
        </Table.Cell>
        <Table.Cell>
          <Button fluid preserveWhitespace
          m={"0%"}
          content={"TESTING"}
          backgroundColor={"red"} />
        </Table.Cell>
        <Table.Cell>
          <Button fluid preserveWhitespace
          m={"0%"}
          content={"TESTING"}
          backgroundColor={"red"} />
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
