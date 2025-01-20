import { useCallback, useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Dropdown, Flex, Input, Modal, Section, Table } from '../components';
import { Window } from '../layouts';

export const SecurityRecords = () => {
  // Le Funny hack cause browse_rsc doesn't get reloaded due to how browser works
  // This adds dynamic parameter to GET request so resource must be refetch
  // Probably could be improved but for now I have no idea how
  const forceReload = (url) => `${url}?t=${Date.now()}`;

  const { data, act } = useBackend();
  const { records = [], user_data, scanner = {}, criminal_statuses } = data;
  const [recordsArray, setRecordsArray] = useState(Array.isArray(records) ? records : []);
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [editField, setEditField] = useState(null); // Field being edited
  const [editValue, setEditValue] = useState(''); // Value for input
  const [commentModalOpen, setCommentModalOpen] = useState(false);
  const [newComment, setNewComment] = useState('');
  const [viewFingerprintScanner, setViewFingerprintScanner] = useState(false); // Track fingerprint scanner view
  const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
  const [filterText, setFilterText] = useState('');
  const [currentPhoto, setCurrentPhoto] = useState('front'); // State to track the current photo (front or side)

  useEffect(() => {
    if (Array.isArray(records)) {
      setRecordsArray(records);
    }
  }, [records]);

  useEffect(() => {
    if (selectedRecord) {
      const updatedRecord = recordsArray.find(record => record.id === selectedRecord.id);
      if (updatedRecord) {
        setSelectedRecord(updatedRecord);
      }else{
        goBack();
      }
    }
  }, [recordsArray, selectedRecord]);

  const handleSave = (value) => {
    act('update_field', { id: selectedRecord.id, field: editField, value });
    closeEditModal();
  };

  const handleAddComment = () => {
    if (newComment.trim()) {
      act('add_comment', { id: selectedRecord.id, comment: newComment });

      setNewComment('');
      closeCommentModal();
    }
  };

  const changePhoto = () => {
    setCurrentPhoto((prevPhoto) => (prevPhoto === 'front' ? 'side' : 'front'));
  };

  const handleUpdatePhoto = () => {
    act('update_photo', { id: selectedRecord.id, photo_profile: currentPhoto });
  };

  const handleSort = (key) => {
    const direction = sortConfig.key === key && sortConfig.direction === 'asc' ? 'desc' : 'asc';
    setSortConfig({ key, direction });

    const sortedRecords = [...recordsArray].sort((a, b) => {
      if (a[key] < b[key]) return direction === 'asc' ? -1 : 1;
      if (a[key] > b[key]) return direction === 'asc' ? 1 : -1;
      return 0;
    });

    setRecordsArray(sortedRecords);
  };

  const filteredRecords = recordsArray.filter((record) =>
    Object.values(record).some((value) =>
      String(value).toLowerCase().includes(filterText.toLowerCase())
    )
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

  const cellStyle = {
    paddingTop: '4px',
    paddingBottom: '3px',
    textAlign: 'center',
  };

  const boxStyle = {
    paddingTop: '5px',
    paddingBottom: '5px',
  };

  const sectionHeaderStyle = {
    paddingTop: '10px',
    paddingBottom: '10px',
  };

  const grayItalicStyle ={
    fontSize: '0.9rem',
    color: 'gray',
    fontStyle: 'italic',
  };

  const personalDataFields = [
    { label: 'Name:', contentKey: 'general_name', isEditable: true, type: 'text' },
    { label: 'ID:', contentKey: 'id', isEditable: false },
    { label: 'Rank:', contentKey: 'general_rank', isEditable: true, type: 'text' },
    { label: 'Sex:', contentKey: 'general_sex', isEditable: true, type: 'select', options: ["Male", "Female"] },
    { label: 'Age:', contentKey: 'general_age', isEditable: true, type: 'number' },
  ];

  const medicalDataFields = [
    { label: 'Physical Status:', contentKey: 'general_p_stat', isEditable: false },
    { label: 'Mental Status:', contentKey: 'general_m_stat', isEditable: false },
  ];

  const securityDataFields = [
    {
      label: 'Criminal Status:',
      contentKey: 'security_criminal',
      isEditable: true,
      type: 'select',
      options: Object.keys(criminal_statuses),
    },
  ];

  const getBackgroundColor = (status) => {
    return criminal_statuses[status]?.background || "inherit"; // Default to white if status is missing
  };

  const getFontColor = (status) => {
    return criminal_statuses[status]?.font || "inherit"; // Default to white if status is missing
  };

  const selectRecord = useCallback(
    (record) => {
      act('select_record', { id: record.id });
      setSelectedRecord(record);
    },
    [act]
  );

  const goBack = useCallback(() => {
    setSelectedRecord(null);
  }, []);

  const renderField = (field, record) => {
    return (
      <Box
        key={field.contentKey}
        style={{
          display: 'flex',
          alignItems: 'center',
          ...boxStyle,
        }}
      >
        <span style={{ minWidth: '120px', textAlign: 'left' }}>{field.label}</span>
        {field.isEditable ? (
          <Button onClick={() => openEditModal(field.contentKey, record[field.contentKey])}>
          {record[field.contentKey]}
          </Button>
        ) : (
          <span>{record[field.contentKey]}</span>
        )}
      </Box>
    );
  };

  const renderFingerprintScannerSection = () => (
    scanner.connected ? (
      <Section title="Fingerprint Scanner">
        <Flex direction="row" gap={2}>
          <Button onClick={() => setViewFingerprintScanner(true)} color="blue">
            Open Fingerprint Scanner
          </Button>
          <Box style={{ ...grayItalicStyle, paddingTop: "4px", paddingLeft: "5px" }}>
                Found {scanner.count} fingerprint{scanner.count > 1 ? "s": ""}
          </Box>
        </Flex>
      </Section>
    ) : null
  );

  const renderFingerprintScannerView = () => (
        <Section title="Fingerprint Scanner">
          {scanner.count > 0 ? (
            <>
              <Box style={{ marginBottom: '10px' }}>
                <strong>Fingerprints:</strong> {scanner.count}
              </Box>
              <Table>
                <Table.Row header>
                  <Table.Cell bold style={cellStyle}>Name</Table.Cell>
                  <Table.Cell bold style={cellStyle}>Rank</Table.Cell>
                  <Table.Cell bold style={cellStyle}>Squad</Table.Cell>
                  <Table.Cell bold style={cellStyle}>Description</Table.Cell>
                </Table.Row>
                {scanner.data.map((fingerprint, index) => (
                  <Table.Row key={index}>
                    <Table.Cell style={cellStyle}>{fingerprint.name || 'Unknown'}</Table.Cell>
                    <Table.Cell style={cellStyle}>{fingerprint.rank || 'Unknown'}</Table.Cell>
                    <Table.Cell style={cellStyle}>{fingerprint.squad || 'Unknown'}</Table.Cell>
                    <Table.Cell style={cellStyle}>{fingerprint.description || 'No Description'}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </>
            ) : (
              <Box>No fingerprints available.</Box>
            )}
              <Flex direction="row" gap={2} style={{ marginTop: '10px' }}>
                <Button onClick={() => { act('print_fingerprint_report'); }} color="green">
                  Print Fingerprint Report
                </Button>
                <Button onClick={() => { act('clear_fingerprints'); }} color="red">
                  Clear Fingerprints
                </Button>
                <Button onClick={() => { act('eject_fingerprint_scanner'); setViewFingerprintScanner(false); }} color="blue">
                  Eject Scanner
                </Button>
              </Flex>
          <hr />
          <Button onClick={() => setViewFingerprintScanner(false)}>Back</Button>
        </Section>
  );

  const renderRecordDetails = (record) => (
        <Section title={`Details for ${record.general_name}`}>
          <Flex direction="column">
            <Flex direction="row" gap={2}>
              <Flex.Item grow={1}>
                <Flex direction="column">
                  <Box textAlign="center" style={sectionHeaderStyle}>Personal Data</Box>
                  {personalDataFields.map((field) => renderField(field, record))}
                </Flex>
              </Flex.Item>

              <Flex.Item>
                <Section title="Photo">
                  <Box style={{ textAlign: 'center', padding: '10px' }}>
                    <img
                      src={forceReload(`${currentPhoto}.png`)}
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
                      <Button onClick={changePhoto} color="green" style={{ minWidth: '60px' }}>
                      {currentPhoto === 'front' ? 'Side' : 'Front'}
                      </Button>
                    </Flex>
                  </Box>
                </Section>
              </Flex.Item>
            </Flex>

            <hr />
            <Box textAlign="center" style={sectionHeaderStyle}>Medical Data</Box>
            {medicalDataFields.map((field) => renderField(field, record))}

            <hr />
            <Box textAlign="center" style={sectionHeaderStyle}>Security Data</Box>
            { !record.security_criminal ? (
              <Box>
                <Box style={{ ...grayItalicStyle, paddingTop: '5px', paddingBottom: '5px' }} >
                  Security record not found
                </Box>
                <Button onClick={() => act('new_security_record', { id: record.id, name: record.general_name })} color="green">
                  Create security record
                </Button>
              </Box>
            ): (
              <>
                {securityDataFields.map((field) => renderField(field, record))}
                <Box style={boxStyle}>
                  Incidents:
                  <div
                    // Data received from in-game system
                    // eslint-disable-next-line react/no-danger
                    dangerouslySetInnerHTML={{
                      __html: record.security_incident || 'None',
                    }}
                  />
                </Box>
                <hr />
                <Box textAlign="center" style={sectionHeaderStyle}>Comments Log</Box>
                <Box style={boxStyle}>
                  {record.security_comments && Object.keys(record.security_comments).length > 0 ? (
                    Object.entries(record.security_comments).map(([key, comment]) => (
                      <Box key={key} style={{ marginBottom: '10px', padding: '5px' }}>
                        {comment.deleted_by ? (
                          <Box style={grayItalicStyle}>
                            Comment deleted by {comment.deleted_by} at {comment.deleted_at || 'unknown time'}.
                          </Box>
                        ) : (
                          <>
                            <Box fontSize="1.2rem">{comment.entry}</Box>
                            <Box style={{ fontSize: '0.9rem', color: 'gray' }}>Created at: {comment.created_at} / {comment?.created_by?.name} ({comment?.created_by?.rank}) </Box>
                            <Button
                              onClick={() => { act('delete_comment', { id: selectedRecord.id, key }); }}
                              mt={1}
                            >
                              Delete
                            </Button>
                          </>
                        )}
                      </Box>
                    ))
                  ) : (
                    'No comments available.'
                  )}
                </Box>
                <Box style={{ ...boxStyle, paddingLeft: '2px' }}>
                  <Button onClick={() => setCommentModalOpen(true)}>Add Comment</Button>
                </Box>
              </>
            )}

            <hr />
            <Flex direction="row" gap={2}>

              <Button onClick={() => act('print_personal_record', { id: record.id })} color="blue">
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

            <hr />
            <Button onClick={goBack}>Back</Button>
          </Flex>
        </Section>
  );

  const renderRecordsTable = () => (
        <Section title="Security Records">
          <Flex direction="row" gap={2} mb={2}>
              <Button onClick={() => { act('new_general_record'); }} color="green">
                New general record
              </Button>
          </Flex>
          <Flex direction="row" gap={2} mb={2}>
            <Input
              placeholder="Search records..."
              value={filterText}
              onInput={(e) => setFilterText(e.target.value)}
              style={{ flexGrow: 1 }}
            />
          </Flex>
          <Table>
            <Table.Row header>
            <Table.Cell
              bold
              style={{ cursor: 'pointer', ...cellStyle }}
              onClick={() => handleSort('general_name')}
            >
              Name {sortConfig.key === 'general_name' && (sortConfig.direction === 'asc' ? '▲' : '▼')}
            </Table.Cell>
            <Table.Cell
              bold
              style={{ cursor: 'pointer', ...cellStyle }}
              onClick={() => handleSort('id')}
            >
              ID {sortConfig.key === 'id' && (sortConfig.direction === 'asc' ? '▲' : '▼')}
            </Table.Cell>
            <Table.Cell
              bold
              style={{ cursor: 'pointer', ...cellStyle }}
              onClick={() => handleSort('general_rank')}
            >
              Rank {sortConfig.key === 'general_rank' && (sortConfig.direction === 'asc' ? '▲' : '▼')}
            </Table.Cell>
            <Table.Cell
              bold
              style={{ cursor: 'pointer', ...cellStyle }}
              onClick={() => handleSort('security_criminal')}
            >
              Status {sortConfig.key === 'security_criminal' && (sortConfig.direction === 'asc' ? '▲' : '▼')}
            </Table.Cell>
            </Table.Row>
            {filteredRecords.map((record) => (
              <Table.Row key={record.id} style={{
                backgroundColor: getBackgroundColor(record.security_criminal),
                color: getFontColor(record.security_criminal),
              }}>
                <Table.Cell style={cellStyle}>
                  <Button
                    onClick={() => {
                      selectRecord(record);
                    }}
                  >
                    {record.general_name}
                  </Button>
                </Table.Cell>
                <Table.Cell style={cellStyle}>{record.id}</Table.Cell>
                <Table.Cell style={cellStyle}>{record.general_rank}</Table.Cell>
                <Table.Cell style={cellStyle}>{record.security_criminal}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
  );

  const renderEditModal = () => {
    const currentField = [...personalDataFields, ...securityDataFields].find(
      (field) => field.contentKey === editField
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
                options={currentField.options}
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
                onInput={(e) => setEditValue(e.target.value)}
                onKeyDown={handleKeyDown}
              />
            )}
            {currentField?.type !== 'select' && (
              <Flex justify="space-between" mt={2}>
                <Button onClick={closeEditModal}>Cancel</Button>
                <Button onClick={() => handleSave(editValue)} color="green" style={{ borderColor: "green" }}>
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
            onInput={(e) => setNewComment(e.target.value)}
            placeholder="Enter your comment..."
          />
          <Flex justify="space-between" mt={2}>
            <Button onClick={closeCommentModal}>Cancel</Button>
            <Button onClick={handleAddComment} color="green" style={{ borderColor: 'green' }}>
              Add Comment
            </Button>
          </Flex>
        </Box>
      </Section>
    </Modal>
  );

  return (
    <Window theme="crtred" width={630} height={700}>
      <Window.Content scrollable>
        {viewFingerprintScanner ? (
          renderFingerprintScannerView()
        ) : selectedRecord ? (
          renderRecordDetails(selectedRecord)
        ) : (
          <>
            {renderFingerprintScannerSection()}
            {renderRecordsTable()}
          </>
        )}
        {editField && renderEditModal()}
        {commentModalOpen && renderCommentModal()}
      </Window.Content>
    </Window>
  );
};
