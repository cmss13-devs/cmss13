/// Generic access for 1:1 conversations with ARES and unrestricted commands.
#define ARES_ACCESS_BASIC 0
/// Secure Access, can read ARES Announcements and Bioscans.
#define ARES_ACCESS_COMMAND 1
#define ARES_ACCESS_JOE 2
/// CL, can read Apollo Log and also Delete Announcements.
#define ARES_ACCESS_CORPORATE 3
/// Senior Command, can Delete Bioscans.
#define ARES_ACCESS_SENIOR 4
/// Synth, CE & Commanding Officer, can read the access log.
#define ARES_ACCESS_CE 5
#define ARES_ACCESS_SYNTH 6
#define ARES_ACCESS_CO 7
/// High Command, can read the deletion log.
#define ARES_ACCESS_HIGH 8
#define ARES_ACCESS_WY_COMMAND 9
/// Debugging. Allows me to view everything without using a high command rank. Unlikely to stay in a full merge.
#define ARES_ACCESS_DEBUG 10

#define ARES_RECORD_ANNOUNCE "Announcement Record"
#define ARES_RECORD_ANTIAIR "AntiAir Control Log"
#define ARES_RECORD_ASRS "Requisition Record"
#define ARES_RECORD_BIOSCAN "Bioscan Record"
#define ARES_RECORD_BOMB "Orbital Bombardment Record"
#define ARES_RECORD_DELETED "Deleted Record"
#define ARES_RECORD_SECURITY "Security Update"
#define ARES_RECORD_MAINTENANCE "Maintenance Ticket"
#define ARES_RECORD_ACCESS "Access Ticket"
#define ARES_RECORD_FLIGHT "Flight Record"

/// Not by ARES logged through marine_announcement()
#define ARES_LOG_NONE 0
/// Logged with all announcements
#define ARES_LOG_MAIN 1
/// Logged in the security updates
#define ARES_LOG_SECURITY 2

// Access levels specifically for Working Joe management console
#define APOLLO_ACCESS_LOGOUT 0
#define APOLLO_ACCESS_REQUEST 1
#define APOLLO_ACCESS_REPORTER 2
#define APOLLO_ACCESS_TEMP 3
#define APOLLO_ACCESS_AUTHED 4
#define APOLLO_ACCESS_JOE 5
#define APOLLO_ACCESS_DEBUG 6

/// Ticket statuses, both for Access and Maintenance
/// Pending assignment/rejection
#define TICKET_PENDING "pending"
/// Assigned to a WJ
#define TICKET_ASSIGNED "assigned"
/// Cancelled by reporter
#define TICKET_CANCELLED "cancelled"
/// Rejected by WJs
#define TICKET_REJECTED "rejected"
/// Completed by WJs
#define TICKET_COMPLETED "completed"

/// Granted Access Ticket
#define TICKET_GRANTED "granted"
/// Revoked Access Ticket
#define TICKET_REVOKED "revoked"
/// Self-Returned Access Ticket
#define TICKET_RETURNED "returned"

/// Checks for if buttons can be used, these may yet be removed and internalised to the UI programming
#define TICKET_OPEN "OPEN"
#define TICKET_CLOSED "CLOSED"

/// Cooldowns
#define COOLDOWN_ARES_SENSOR 60 SECONDS
#define COOLDOWN_ARES_ACCESS_CONTROL 20 SECONDS
