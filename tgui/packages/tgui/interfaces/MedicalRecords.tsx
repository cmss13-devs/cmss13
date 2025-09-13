import { capitalize } from 'common/string';
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
  general_job: string;
  general_age: number;
  general_sex: string;
  general_m_stat: string;
  general_p_stat: string;
  medical_blood_type: string;
  medical_diseases: string;
  medical_diseases_details: string;
  medical_allergies: string;
  medical_allergies_details: string;
  medical_major_disability: string;
  medical_major_disability_details: string;
  medical_minor_disability: string;
  medical_minor_disability_details: string;
  medical_comments: {
    entry: string;
    created_by: { name: string; rank: string };
    created_at: String;
    deleted_by: null | string;
    deleted_at: null | string;
  }[];
  record_classified: Boolean;
};

type Data = {
  records: RecordEntry[];
  operator: string;
  database_access_level: number;
  fallback_image: string;
  photo_front?: string;
  photo_side?: string;
};

export const MedicalRecords = () => {
  const { data, act } = useBackend<Data>();
  const { records = [], fallback_image } = data;
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

  let view_record = false;
  let edit_record = false;

  if (
    data.database_access_level >= (selectedRecord?.record_classified ? 1 : 0)
  ) {
    view_record = true;
  }

  if (
    data.database_access_level > (selectedRecord?.record_classified ? 1 : 0)
  ) {
    edit_record = true;
  }

  let medical_record_action = 'new';

  if (selectedRecord?.general_p_stat) {
    medical_record_action = 'delete';
  }

  const personalDataFields = [
    { label: 'ID:', contentKey: 'id', isEditable: false },
    {
      label: 'RANK:',
      contentKey: 'general_rank',
      isEditable: false,
      type: 'string',
    },
    {
      label: 'SEX:',
      contentKey: 'general_sex',
      isEditable: edit_record,
      type: 'select',
      options: ['Male', 'Female'],
    },
    {
      label: 'AGE:',
      contentKey: 'general_age',
      isEditable: edit_record,
      type: 'number',
    },
  ];

  const medicalDataFields = [
    {
      label: 'Physical Status:',
      contentKey: 'general_p_stat',
      isEditable: edit_record,
      type: 'select',
      options: ['Active', 'Physically Unfit', 'Disabled', 'SSD', 'Deceased'],
    },
    {
      label: 'Mental Status:',
      contentKey: 'general_m_stat',
      isEditable: edit_record,
      type: 'select',
      options: ['Stable', 'Watch', 'Unstable', 'Insane'],
    },
    {
      label: 'Blood Type:',
      contentKey: 'medical_blood_type',
      isEditable: edit_record,
      type: 'select',
      options: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
    },
  ];

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
      <Box key={field.contentKey} minWidth="45px">
        <Box fontWeight="500" fontSize="10px">
          {field.label}
        </Box>
        {field.isEditable ? (
          <Button
            compact
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

  const renderSecondaryField = (label, field, record_data, record) => {
    return (
      <Flex direction="column">
        <Flex.Item fontWeight="700" fontSize="11px">
          {label.toUpperCase()}:
        </Flex.Item>
        <Flex.Item fontWeight="600" fontSize="10px">
          {record_data}
        </Flex.Item>
        {edit_record && (
          <Flex.Item>
            <Button
              compact
              className="MedicalRecords_Button"
              fontWeight="700"
              fontSize="11px"
              mt="3px"
              onClick={() => openEditModal(field, record[field])}
            >
              Add Entry
            </Button>
          </Flex.Item>
        )}
      </Flex>
    );
  };

  const renderRecordDetails = (record: RecordEntry) => (
    <Section
      m="0"
      pl="10px"
      pr="10px"
      title={`MEDICAL RECORD - ${record.general_name.toUpperCase()}`}
      buttons={
        <Flex>
          <Box fontFamily="monospace" bold mt="2px" mr="7px">
            | DATABASE ACCESS LEVEL {data.database_access_level} |
          </Box>

          <Button
            compact
            fluid
            width="85px"
            mr="10px"
            textAlign="center"
            onClick={() => act('log_out')}
          >
            Log Out
          </Button>
        </Flex>
      }
      minHeight="100%"
    >
      <Flex direction="column" p="10px">
        <Flex.Item>
          <Flex direction="row" gap={2}>
            <Flex.Item width="65%">
              <Flex direction="column">
                <Flex.Item>
                  <Box className="MedicalRecords_SectionHeaderStyle">
                    FULL NAME:
                  </Box>
                  <Box fontWeight="900" fontSize="25px">
                    {record.general_name.toUpperCase()}
                  </Box>
                </Flex.Item>
              </Flex>
              <Flex direction="row">
                <Flex.Item fontWeight="500" fontSize="10px">
                  POSITION:
                </Flex.Item>
                <Flex.Item fontWeight="700" fontSize="10px" ml="5px">
                  {record.general_job.toUpperCase()}
                </Flex.Item>
              </Flex>
              <Box width="95%">
                <Divider />
              </Box>
              <Flex
                direction="row"
                width="95%"
                justify="space-between"
                mt="10px"
                mb="10px"
              >
                {personalDataFields.map((field) => renderField(field, record))}
              </Flex>
              <Box width="95%">
                <Divider />
              </Box>

              <Flex
                direction="row"
                width="95%"
                justify="space-between"
                mt="15px"
                mb="15px"
              >
                {medicalDataFields.map((field) => renderField(field, record))}
                <Flex.Item />
              </Flex>
              <Box width="95%">
                <Divider />
              </Box>
              <Box
                className="MedicalRecords_SectionHeaderStyle"
                mb="5px"
                mt="10px"
                fontSize="14px"
              >
                MEDICAL DATA
              </Box>
            </Flex.Item>

            <Flex.Item grow>
              <Section m="0" style={{ aspectRatio: `1` }}>
                <Box style={{ textAlign: 'center', padding: '10px' }}>
                  <img
                    src={
                      currentPhoto === 'front'
                        ? recordPhotos.front
                        : recordPhotos.side
                    }
                    alt="INFORMATION LOST"
                    style={{
                      borderRadius: '4px',
                      border: '1px solid var(--border-color)',
                      width: '100px',
                      height: '100px',
                    }}
                  />
                </Box>
                <Flex
                  direction="row"
                  gap={2}
                  justify="center"
                  textAlign="center"
                >
                  <Button onClick={handleUpdatePhoto}>Update</Button>
                  <Button onClick={changePhoto} style={{ minWidth: '60px' }}>
                    {currentPhoto === 'front' ? 'Side' : 'Front'}
                  </Button>
                </Flex>
              </Section>
            </Flex.Item>
          </Flex>
        </Flex.Item>
        {view_record && record.general_p_stat ? (
          <>
            <Flex.Item pt="5px" ml="-5px" mb="12px">
              <Flex direction="row">
                <Flex.Item>
                  <Divider vertical />
                </Flex.Item>
                <Flex.Item width="46%">
                  {renderSecondaryField(
                    'diseases',
                    'medical_diseases',
                    record.medical_diseases,
                    record,
                  )}
                </Flex.Item>
                <Flex.Item>
                  <Divider vertical />
                </Flex.Item>
                <Flex.Item width="46%">
                  {renderSecondaryField(
                    'allergies',
                    'medical_allergies',
                    record.medical_allergies,
                    record,
                  )}
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item mb="5px" ml="-5px">
              <Flex direction="row">
                <Flex.Item>
                  <Divider vertical />
                </Flex.Item>
                <Flex.Item width="46%">
                  {renderSecondaryField(
                    'major disabilities',
                    'medical_major_disability',
                    record.medical_major_disability,
                    record,
                  )}
                </Flex.Item>
                <Flex.Item>
                  <Divider vertical />
                </Flex.Item>
                <Flex.Item>
                  {renderSecondaryField(
                    'minor disabilities',
                    'medical_minor_disability',
                    record.medical_minor_disability,
                    record,
                  )}
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </>
        ) : (
          <Flex.Item height="120px">
            <>
              <Box
                fontWeight={900}
                mt="45px"
                textAlign="center"
                fontSize="15px"
              >
                - MEDICAL DATA UNAVAILABLE -
              </Box>
              <Box
                fontWeight={700}
                mt="3px"
                mb="45px"
                textAlign="center"
                fontSize="11px"
              >
                {record.general_m_stat
                  ? 'INSUFFICIENT ACCESS CREDENTIALS'
                  : 'MEDICAL DATA NOT FOUND'}
              </Box>
            </>
          </Flex.Item>
        )}
        <Flex.Item>
          <Divider />
        </Flex.Item>
        <Flex.Item ml="-5px" mt="5px" grow>
          {view_record && record.general_p_stat ? (
            <Flex>
              <Flex.Item>
                <Divider vertical />
              </Flex.Item>
              <Flex.Item>
                <Box fontWeight="700" fontSize="11px" mb="5px" mt="5px">
                  COMMENTS / LOG
                </Box>
                <Box
                  className="MedicalRecords_BoxStyle"
                  style={{ paddingLeft: '2px' }}
                  minHeight="105px"
                >
                  <Box className="MedicalRecords_BoxStyle">
                    {record.medical_comments &&
                    Object.keys(record.medical_comments).length > 0
                      ? Object.entries(record.medical_comments).map(
                          ([key, comment]) => (
                            <Box
                              key={key}
                              style={{ marginBottom: '5px', padding: '2px' }}
                            >
                              {comment.deleted_by ? (
                                <Box className="MedicalRecords_GrayItalicStyle">
                                  Comment deleted by {comment.deleted_by} at{' '}
                                  {comment.deleted_at || 'unknown time'}.
                                </Box>
                              ) : (
                                <>
                                  <Box fontSize="12px">{comment.entry}</Box>
                                  <Box
                                    style={{
                                      fontSize: '0.9rem',
                                      color: 'gray',
                                    }}
                                  >
                                    Created at: {comment.created_at} /{' '}
                                    {comment?.created_by?.name} (
                                    {comment?.created_by?.rank}){' '}
                                  </Box>
                                  {edit_record && (
                                    <Button
                                      compact
                                      fontWeight="700"
                                      fontSize="11px"
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
                                  )}
                                </>
                              )}
                            </Box>
                          ),
                        )
                      : 'No comments available.'}
                  </Box>
                  {edit_record && (
                    <Button
                      compact
                      className="MedicalRecords_Button"
                      fontWeight="700"
                      fontSize="11px"
                      onClick={openCommentModal}
                    >
                      Add Comment
                    </Button>
                  )}
                </Box>
              </Flex.Item>
            </Flex>
          ) : (
            <>
              <Box
                fontWeight={900}
                mt="45px"
                textAlign="center"
                fontSize="15px"
              >
                - COMMENT DATA UNAVAILABLE -
              </Box>
              <Box
                fontWeight={700}
                mt="3px"
                mb="45px"
                textAlign="center"
                fontSize="11px"
              >
                {record.general_p_stat
                  ? 'INSUFFICIENT ACCESS CREDENTIALS'
                  : 'MEDICAL DATA NOT FOUND'}
              </Box>
            </>
          )}
        </Flex.Item>
      </Flex>

      <Divider />
      <Flex justify="space-between" direction="row" gap={2} pl="10px" pr="10px">
        {data.database_access_level >= 1 ? (
          <Button
            width="48%"
            textAlign="center"
            onClick={() => act('print_medical_record', { id: record.id })}
          >
            Print record
          </Button>
        ) : (
          <Button
            width="48%"
            textAlign="center"
            backgroundColor="transparent"
            color="#00eb4e"
            tooltip="Insufficient access credentials!"
          >
            Print record
          </Button>
        )}
        {data.database_access_level >= 2 ? (
          <Button.Confirm
            width="48%"
            textAlign="center"
            confirmColor="bad"
            confirmContent="Confirm?"
            onClick={() =>
              act(medical_record_action + '_medical_record', {
                id: record.id,
                name: record.general_name,
              })
            }
          >
            {capitalize(medical_record_action)} medical record
          </Button.Confirm>
        ) : (
          <Button
            width="48%"
            textAlign="center"
            backgroundColor="transparent"
            color="#00eb4e"
            tooltip="Insufficient access credentials!"
          >
            {capitalize(medical_record_action)} medical record
          </Button>
        )}
      </Flex>

      <Divider />
      <Button ml="8px" mr="8px" onClick={goBack} mt="10px" mb="10px" fluid>
        Back
      </Button>
    </Section>
  );

  const renderRecordsTable = () => (
    <Section fill m="0" pr="0.5%" pl="0.5%">
      <Flex justify="space-evenly">
        <Box bold fontSize="20px">
          Medical Records
        </Box>
      </Flex>
      <Divider />
      <Flex justify="space-evenly" direction="row" gap={2} mb={1}>
        {data.database_access_level >= 2 ? (
          <Button
            width="140px"
            textAlign="center"
            onClick={() => {
              act('new_general_record');
            }}
          >
            New general record
          </Button>
        ) : (
          <Button
            width="140px"
            bold
            textAlign="center"
            backgroundColor="transparent"
            color="#00eb4e"
            tooltip="Insufficient access credentials!"
          >
            New general record
          </Button>
        )}
        <Button
          width="200px"
          bold
          textAlign="center"
          backgroundColor="transparent"
          color="#00eb4e"
        >
          | DATABASE ACCESS LEVEL {data.database_access_level} |
        </Button>
        <Button width="140px" textAlign="center" onClick={() => act('log_out')}>
          Log Out
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
            className="MedicalRecords_CellStyle MedicalRecords_CursorPointer"
            onClick={() => handleSort('general_name')}
          >
            Name {getSortIndicator('general_name')}
          </Table.Cell>
          <Table.Cell
            bold
            className="MedicalRecords_CellStyle MedicalRecords_CursorPointer"
            onClick={() => handleSort('id')}
          >
            ID {getSortIndicator('id')}
          </Table.Cell>
          <Table.Cell
            bold
            className="MedicalRecords_CellStyle MedicalRecords_CursorPointer"
            onClick={() => handleSort('general_job')}
          >
            Position {getSortIndicator('general_job')}
          </Table.Cell>
          <Table.Cell
            bold
            className="MedicalRecords_CellStyle MedicalRecords_CursorPointer"
            onClick={() => handleSort('general_p_stat')}
          >
            Status {getSortIndicator('general_p_stat')}
          </Table.Cell>
        </Table.Row>
        {filteredRecords.map((record) => (
          <Table.Row key={record.id}>
            <Table.Cell className="MedicalRecords_CellStyle">
              <Button
                onClick={() => {
                  selectRecord(record);
                }}
              >
                {record.general_name}
              </Button>
            </Table.Cell>
            <Table.Cell className="MedicalRecords_CellStyle">
              {record.id}
            </Table.Cell>
            <Table.Cell className="MedicalRecords_CellStyle">
              {record.general_job}
            </Table.Cell>
            <Table.Cell className="MedicalRecords_CellStyle">
              {record.general_p_stat}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );

  const LoginPanel = (props) => {
    return (
      <Section
        fill
        textAlign="center"
        align="center"
        height="100%"
        fontSize="2rem"
        bold
        pt="0%"
      >
        <Box fontSize={1.8}>MEDICAL RECORDS DATABASE</Box>
        <Box fontSize={1}>
          [ Version 1.2.8 | Copyright © 2182, Weyland Yutani Corp. ]
        </Box>
        <Divider />
        <Box mt="25%">
          <Divider />
        </Box>
        <Box fontSize={1.5} mt="5%">
          INTERFACE ACCESS RESTRICTED
        </Box>
        <Box fontFamily="monospace" fontSize={1.3}>
          [ IDENTITY VERIFICATION REQUIRED ]
        </Box>

        <Button
          icon="id-card"
          width="60vw"
          textAlign="center"
          fontSize={1.3}
          p={0.7}
          m="1rem"
          onClick={() => act('log_in')}
        >
          Login
        </Button>

        <Box fontFamily="monospace" fontSize={1.2} mb="5%">
          - UNAUTHORIZED USE STRICTLY PROHIBITED -
        </Box>
        <Divider />
      </Section>
    );
  };

  const renderEditModal = () => {
    const currentField = [...personalDataFields, ...medicalDataFields].find(
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
    <Window theme="crtgreen" width={630} height={700}>
      <Window.Content>
        {data.operator ? (
          <Section fill scrollable fitted>
            {selectedRecord ? (
              renderRecordDetails(selectedRecord)
            ) : (
              <Flex>
                <Flex.Item width="100%">{renderRecordsTable()}</Flex.Item>
              </Flex>
            )}
            {editField && renderEditModal()}
          </Section>
        ) : (
          <LoginPanel />
        )}
        {commentModalOpen && renderCommentModal()}
      </Window.Content>
    </Window>
  );
};
