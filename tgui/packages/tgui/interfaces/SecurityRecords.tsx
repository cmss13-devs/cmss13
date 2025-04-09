import type { BooleanLike } from 'common/react';
import { useCallback, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  Input,
  Modal,
  Section,
  Table,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type RecordEntry = {
  id: string;
  general_name: string;
  general_rank: string;
  general_age: number;
  general_sex: string;
  general_m_stat: string;
  general_p_stat: string;
  security_criminal: string;
  security_comments: {
    entry: string;
    created_by: { name: string; rank: string };
    created_at: String;
    deleted_by: null | string;
    deleted_at: null | string;
  }[];
  security_incident: string | null;
};

type Scanner = {
  connected: BooleanLike;
  count: number;
  data: { name: string; squad: string; rank: string; description: string }[];
};

type Data = {
  scanner: Scanner;
  records: RecordEntry[];
  fallback_image: string;
  photo_front?: string;
  photo_side?: string;
};

export const SecurityRecords = () => {
  const { data, act } = useBackend<Data>();
  const { records = [], scanner = {} as Scanner, fallback_image } = data;
  const [recordsArray, setRecordsArray] = useState(
    Array.isArray(records) ? records : [],
  );
  const [selectedRecord, setSelectedRecord] = useState<RecordEntry | null>(
    null,
  );
  const [editField, setEditField] = useState(null); // Field being edited
  const [editValue, setEditValue] = useState(''); // Value for input
  const [commentModalOpen, setCommentModalOpen] = useState(false);
  const [newComment, setNewComment] = useState('');
  const [viewFingerprintScanner, setViewFingerprintScanner] = useState(false); // Track fingerprint scanner view
  const [sortConfig, setSortConfig] = useState({
    key: 'general_name',
    direction: 'asc',
  });
  const [filterText, setFilterText] = useState('');
  const [currentPhoto, setCurrentPhoto] = useState('front'); // State to track the current photo (front or side)
  const [recordPhotos, setRecordPhotos] = useState({
    front: '',
    side: '',
  });

  // useEffect to sort on data update and on sort config change
  useEffect(() => {
    if (Array.isArray(records)) {
      let updatedRecords = [...records];

      if (sortConfig.key) {
        updatedRecords.sort((a, b) => {
          if (a[sortConfig.key] < b[sortConfig.key]) {
            return sortConfig.direction === 'asc' ? -1 : 1;
          }
          if (a[sortConfig.key] > b[sortConfig.key]) {
            return sortConfig.direction === 'asc' ? 1 : -1;
          }
          return 0;
        });
      }

      setRecordsArray(updatedRecords);
    }
  }, [records, sortConfig]);

  useEffect(() => {
    if (selectedRecord) {
      const updatedRecord = recordsArray.find(
        (record) => record.id === selectedRecord.id,
      );
      if (updatedRecord) {
        setSelectedRecord(updatedRecord);
      } else {
        goBack();
      }
    }

    if (data.photo_front || data.photo_side) {
      setRecordPhotos({
        front: data.photo_front || fallback_image,
        side: data.photo_side || fallback_image,
      });
    }
  }, [recordsArray, selectedRecord]);

  const handleSave = (value) => {
    act('update_field', { id: selectedRecord?.id, field: editField, value });
    closeEditModal();
  };

  const handleAddComment = () => {
    if (newComment.trim()) {
      act('add_comment', { id: selectedRecord?.id, comment: newComment });

      setNewComment('');
      closeCommentModal();
    }
  };

  const changePhoto = () => {
    setCurrentPhoto((prevPhoto) => (prevPhoto === 'front' ? 'side' : 'front'));
  };

  const handleUpdatePhoto = () => {
    act('update_photo', {
      id: selectedRecord?.id,
      photo_profile: currentPhoto,
    });
  };

  const handleSort = (key, keepDirection = false) => {
    const direction =
      keepDirection && sortConfig.key === key
        ? sortConfig.direction
        : sortConfig.key === key && sortConfig.direction === 'asc'
          ? 'desc'
          : 'asc';

    setSortConfig({ key, direction });
  };

  const filteredRecords = recordsArray.filter((record) =>
    Object.values(record).some((value) =>
      String(value).toLowerCase().includes(filterText.toLowerCase()),
    ),
  );

  //* Functions for handling modals state

  const openEditModal = (field, value) => {
    setEditField(field);
    setEditValue(value);
  };

  const closeEditModal = () => {
    setEditField(null);
    setEditValue('');
  };

  const openCommentModal = () => {
    setCommentModalOpen(true);
  };

  const closeCommentModal = () => {
    setCommentModalOpen(false);
    setNewComment('');
  };

  const personalDataFields = [
    {
      label: 'Name:',
      contentKey: 'general_name',
      isEditable: true,
      type: 'text',
    },
    { label: 'ID:', contentKey: 'id', isEditable: false },
    {
      label: 'Position:',
      contentKey: 'general_rank',
      isEditable: true,
      type: 'text',
    },
    {
      label: 'Sex:',
      contentKey: 'general_sex',
      isEditable: true,
      type: 'select',
      options: ['Male', 'Female'],
    },
    {
      label: 'Age:',
      contentKey: 'general_age',
      isEditable: true,
      type: 'number',
    },
  ];

  const medicalDataFields = [
    {
      label: 'Physical Status:',
      contentKey: 'general_p_stat',
      isEditable: false,
    },
    {
      label: 'Mental Status:',
      contentKey: 'general_m_stat',
      isEditable: false,
    },
  ];

  const criminalStatuses = {
    '*Arrest*': { background: '#990c28', font: '#ffffff' },
    Incarcerated: { background: '#faa20a', font: '#ffffff' },
    Released: { background: '#2981b3', font: '#ffffff' },
    Suspect: { background: '#686A6C', font: '#ffffff' },
    NJP: { background: '#b60afa', font: '#ffffff' },
    None: { background: 'inherit', font: 'inherit' },
  };

  const securityDataFields = [
    {
      label: 'Criminal Status:',
      contentKey: 'security_criminal',
      isEditable: true,
      type: 'select',
      options: Object.keys(criminalStatuses),
    },
  ];

  // Function to get styles based on status
  const getStyle = (status) =>
    criminalStatuses[status] || { background: 'inherit', font: 'inherit' };

  const getSortIndicator = (key) => {
    if (sortConfig.key === key) {
      return sortConfig.direction === 'asc' ? '▼' : '▲';
    }
  };

  const selectRecord = useCallback(
    (record) => {
      act('select_record', { id: record.id });
      setSelectedRecord(record);
    },
    [act],
  );

  const goBack = useCallback(() => {
    setSelectedRecord(null);
  }, []);

  const renderField = (field, record) => {
    return (
      <Box
        key={field.contentKey}
        className="SecurityRecords_BoxStyle"
        style={{
          display: 'flex',
          alignItems: 'center',
        }}
      >
        <span style={{ minWidth: '120px', textAlign: 'left' }}>
          {field.label}
        </span>
        {field.isEditable ? (
          <Button
            onClick={() =>
              openEditModal(field.contentKey, record[field.contentKey])
            }
          >
            {record[field.contentKey]}
          </Button>
        ) : (
          <span>{record[field.contentKey]}</span>
        )}
      </Box>
    );
  };

  const renderFingerprintScannerSection = () =>
    scanner.connected ? (
      <Section title="Fingerprint Scanner">
        <Flex direction="row" gap={2}>
          <Button onClick={() => setViewFingerprintScanner(true)} color="blue">
            Open Fingerprint Scanner
          </Button>
          <Box
            className="SecurityRecords_GrayItalicStyle"
            style={{
              paddingTop: '4px',
              paddingLeft: '5px',
            }}
          >
            Found {scanner.count} fingerprint{scanner.count > 1 ? 's' : ''}
          </Box>
        </Flex>
      </Section>
    ) : null;

  const renderFingerprintScannerView = () => (
    <Section title="Fingerprint Scanner">
      {scanner.count > 0 ? (
        <>
          <Box style={{ marginBottom: '10px' }}>
            <strong>Fingerprints:</strong> {scanner.count}
          </Box>
          <Table>
            <Table.Row header>
              <Table.Cell bold className="SecurityRecords_CellStyle">
                Name
              </Table.Cell>
              <Table.Cell bold className="SecurityRecords_CellStyle">
                Position
              </Table.Cell>
              <Table.Cell bold className="SecurityRecords_CellStyle">
                Squad
              </Table.Cell>
              <Table.Cell bold className="SecurityRecords_CellStyle">
                Description
              </Table.Cell>
            </Table.Row>
            {scanner.data.map((fingerprint, index) => (
              <Table.Row key={index}>
                <Table.Cell className="SecurityRecords_CellStyle">
                  {fingerprint.name || 'Unknown'}
                </Table.Cell>
                <Table.Cell className="SecurityRecords_CellStyle">
                  {fingerprint.rank || 'Unknown'}
                </Table.Cell>
                <Table.Cell className="SecurityRecords_CellStyle">
                  {fingerprint.squad || 'Unknown'}
                </Table.Cell>
                <Table.Cell className="SecurityRecords_CellStyle">
                  {fingerprint.description || 'No Description'}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </>
      ) : (
        <Box>No fingerprints available.</Box>
      )}
      <Flex direction="row" gap={2} style={{ marginTop: '10px' }}>
        <Button
          onClick={() => {
            act('print_fingerprint_report');
          }}
          color="green"
        >
          Print Fingerprint Report
        </Button>
        <Button
          onClick={() => {
            act('clear_fingerprints');
          }}
          color="red"
        >
          Clear Fingerprints
        </Button>
        <Button
          onClick={() => {
            act('eject_fingerprint_scanner');
            setViewFingerprintScanner(false);
          }}
          color="blue"
        >
          Eject Scanner
        </Button>
      </Flex>
      <Divider />
      <Button onClick={() => setViewFingerprintScanner(false)}>Back</Button>
    </Section>
  );

  const renderRecordDetails = (record: RecordEntry) => (
    <Section m="0" title={`Details for ${record.general_name}`}>
      <Flex direction="column">
        <Flex direction="row" gap={2}>
          <Flex.Item grow={1}>
            <Flex direction="column">
              <Box
                textAlign="center"
                className="SecurityRecords_SectionHeaderStyle"
              >
                Personal Data
              </Box>
              {personalDataFields.map((field) => renderField(field, record))}
            </Flex>
          </Flex.Item>

          <Flex.Item>
            <Section title="Photo" m="0">
              <Box style={{ textAlign: 'center', padding: '10px' }}>
                <img
                  src={
                    currentPhoto === 'front'
                      ? recordPhotos.front
                      : recordPhotos.side
                  }
                  alt="Perp photo"
                  style={{
                    borderRadius: '4px',
                    border: '1px solid var(--border-color)',
                    width: '100px',
                    height: '100px',
                  }}
                />
                <Flex direction="row" gap={2}>
                  <Button onClick={handleUpdatePhoto} color="blue">
                    Update
                  </Button>
                  <Button
                    onClick={changePhoto}
                    color="green"
                    style={{ minWidth: '60px' }}
                  >
                    {currentPhoto === 'front' ? 'Side' : 'Front'}
                  </Button>
                </Flex>
              </Box>
            </Section>
          </Flex.Item>
        </Flex>

        <Divider />
        <Box textAlign="center" className="SecurityRecords_SectionHeaderStyle">
          Medical Data
        </Box>
        {medicalDataFields.map((field) => renderField(field, record))}

        <Divider />
        <Box textAlign="center" className="SecurityRecords_SectionHeaderStyle">
          Security Data
        </Box>
        {!record.security_criminal ? (
          <Box>
            <Box
              className="SecurityRecords_GrayItalicStyle"
              style={{
                paddingTop: '5px',
                paddingBottom: '5px',
              }}
            >
              Security record not found
            </Box>
            <Button
              onClick={() =>
                act('new_security_record', {
                  id: record.id,
                  name: record.general_name,
                })
              }
              color="green"
            >
              Create security record
            </Button>
          </Box>
        ) : (
          <>
            {securityDataFields.map((field) => renderField(field, record))}
            <Box className="SecurityRecords_BoxStyle">
              Incidents:
              <div
                // Data received from in-game system
                // eslint-disable-next-line react/no-danger
                dangerouslySetInnerHTML={{
                  __html: record.security_incident || 'None',
                }}
              />
            </Box>
            <Divider />
            <Box
              textAlign="center"
              className="SecurityRecords_SectionHeaderStyle"
            >
              Comments Log
            </Box>
            <Box className="SecurityRecords_BoxStyle">
              {record.security_comments &&
              Object.keys(record.security_comments).length > 0
                ? Object.entries(record.security_comments).map(
                    ([key, comment]) => (
                      <Box
                        key={key}
                        style={{ marginBottom: '10px', padding: '5px' }}
                      >
                        {comment.deleted_by ? (
                          <Box className="SecurityRecords_GrayItalicStyle">
                            Comment deleted by {comment.deleted_by} at{' '}
                            {comment.deleted_at || 'unknown time'}.
                          </Box>
                        ) : (
                          <>
                            <Box fontSize="1.2rem">{comment.entry}</Box>
                            <Box style={{ fontSize: '0.9rem', color: 'gray' }}>
                              Created at: {comment.created_at} /{' '}
                              {comment?.created_by?.name} (
                              {comment?.created_by?.rank}){' '}
                            </Box>
                            <Button
                              onClick={() => {
                                act('delete_comment', {
                                  id: selectedRecord?.id,
                                  key,
                                });
                              }}
                              mt={1}
                            >
                              Delete
                            </Button>
                          </>
                        )}
                      </Box>
                    ),
                  )
                : 'No comments available.'}
            </Box>
            <Box
              className="SecurityRecords_BoxStyle"
              style={{ paddingLeft: '2px' }}
            >
              <Button onClick={openCommentModal}>Add Comment</Button>
            </Box>
          </>
        )}

        <Divider />
        <Flex justify="space-between" direction="row" gap={2}>
          <Button
            onClick={() => act('print_personal_record', { id: record.id })}
            color="blue"
          >
            Print record
          </Button>
          <Button.Confirm
            fluid
            color="red"
            confirmColor="bad"
            confirmContent="Confirm?"
            onClick={() => act('delete_general_record', { id: record.id })}
          >
            Delete general record
          </Button.Confirm>
        </Flex>

        <Divider />
        <Button onClick={goBack}>Back</Button>
      </Flex>
    </Section>
  );

  const renderRecordsTable = () => (
    <Section fill m="0" pr="0.5%" pl="0.5%">
      <Flex justify="space-evenly">
        <Box bold fontSize="20px">
          Security Records
        </Box>
      </Flex>
      <Divider />
      <Flex justify="space-evenly" direction="row" gap={2} mb={2}>
        <Button
          onClick={() => {
            act('new_general_record');
          }}
          color="green"
        >
          New general record
        </Button>
      </Flex>
      <Flex direction="row" gap={2} mb={2}>
        <Input
          placeholder="Search records..."
          value={filterText}
          onInput={(e, value) => setFilterText(value)}
          style={{ flexGrow: '1' }}
        />
      </Flex>
      <Table>
        <Table.Row header>
          <Table.Cell
            bold
            className="SecurityRecords_CellStyle SecurityRecords_CursorPointer"
            onClick={() => handleSort('general_name')}
          >
            Name {getSortIndicator('general_name')}
          </Table.Cell>
          <Table.Cell
            bold
            className="SecurityRecords_CellStyle SecurityRecords_CursorPointer"
            onClick={() => handleSort('id')}
          >
            ID {getSortIndicator('id')}
          </Table.Cell>
          <Table.Cell
            bold
            className="SecurityRecords_CellStyle SecurityRecords_CursorPointer"
            onClick={() => handleSort('general_rank')}
          >
            Position {getSortIndicator('general_rank')}
          </Table.Cell>
          <Table.Cell
            bold
            className="SecurityRecords_CellStyle SecurityRecords_CursorPointer"
            onClick={() => handleSort('security_criminal')}
          >
            Status {getSortIndicator('security_criminal')}
          </Table.Cell>
        </Table.Row>
        {filteredRecords.map((record) => (
          <Table.Row
            key={record.id}
            style={{
              backgroundColor: getStyle(record.security_criminal).background,
              color: getStyle(record.security_criminal).font,
            }}
          >
            <Table.Cell className="SecurityRecords_CellStyle">
              <Button
                onClick={() => {
                  selectRecord(record);
                }}
              >
                {record.general_name}
              </Button>
            </Table.Cell>
            <Table.Cell className="SecurityRecords_CellStyle">
              {record.id}
            </Table.Cell>
            <Table.Cell className="SecurityRecords_CellStyle">
              {record.general_rank}
            </Table.Cell>
            <Table.Cell className="SecurityRecords_CellStyle">
              {record.security_criminal}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );

  const renderEditModal = () => {
    const currentField = [...personalDataFields, ...securityDataFields].find(
      (field) => field.contentKey === editField,
    );

    const handleKeyDown = (e) => {
      if (e.key === 'Enter') {
        handleSave(editValue);
      }
    };

    return (
      <Modal width="100%">
        <Section title={`Edit ${currentField?.label || 'Field'}`} width="250px">
          <Box>
            {currentField?.type === 'select' ? (
              <Dropdown
                width="100%"
                options={currentField.options!}
                selected={editValue}
                onSelected={(value) => handleSave(value)}
              />
            ) : (
              <Input
                autoFocus
                autoSelect
                width="100%"
                type={currentField?.type === 'number' ? 'number' : 'text'}
                value={editValue}
                onInput={(e, value) => setEditValue(value)}
                onKeyDown={handleKeyDown}
              />
            )}
            {currentField?.type !== 'select' && (
              <Flex justify="space-between" mt={2}>
                <Button onClick={closeEditModal}>Cancel</Button>
                <Button
                  onClick={() => handleSave(editValue)}
                  color="green"
                  style={{ borderColor: 'green' }}
                >
                  Save
                </Button>
              </Flex>
            )}
          </Box>
        </Section>
      </Modal>
    );
  };

  const renderCommentModal = () => (
    <Modal width="400px">
      <Section title="Add Comment">
        <Box>
          <Input
            width="100%"
            value={newComment}
            onInput={(e, value) => setNewComment(value)}
            placeholder="Enter your comment..."
          />
          <Flex justify="space-between" mt={2}>
            <Button onClick={closeCommentModal}>Cancel</Button>
            <Button
              onClick={handleAddComment}
              color="green"
              style={{ borderColor: 'green' }}
            >
              Add Comment
            </Button>
          </Flex>
        </Box>
      </Section>
    </Modal>
  );

  return (
    <Window theme="crtred" width={630} height={700}>
      <Window.Content>
        <Section fill scrollable>
          {viewFingerprintScanner ? (
            renderFingerprintScannerView()
          ) : selectedRecord ? (
            renderRecordDetails(selectedRecord)
          ) : (
            <Flex>
              <Flex.Item width="100%">
                {renderFingerprintScannerSection()}
                {renderRecordsTable()}
              </Flex.Item>
            </Flex>
          )}
          {editField && renderEditModal()}
        </Section>
        {commentModalOpen && renderCommentModal()}
      </Window.Content>
    </Window>
  );
};
