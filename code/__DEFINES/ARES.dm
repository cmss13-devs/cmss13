#define ARES_ACCESS_LOGOUT 0
/// Generic access for 1:1 conversations with ARES and unrestricted commands.
#define ARES_ACCESS_BASIC 1
/// Secure Access, can read ARES Announcements and Bioscans.
#define ARES_ACCESS_COMMAND 2
#define ARES_ACCESS_JOE 3
/// CL, can read Apollo Log and also Delete Announcements.
#define ARES_ACCESS_CORPORATE 4
/// Senior Command, can Delete Bioscans.
#define ARES_ACCESS_SENIOR 5
/// Synth, CE & Commanding Officer, can read the access log.
#define ARES_ACCESS_CE 6
#define ARES_ACCESS_SYNTH 7
#define ARES_ACCESS_CO 8
/// High Command, can read the deletion log.
#define ARES_ACCESS_HIGH 9
#define ARES_ACCESS_WY_COMMAND 10
/// Debugging. Allows me to view everything without using a high command rank.
#define ARES_ACCESS_DEBUG 11

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
#define ARES_RECORD_TECH "Tech Control Record"

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

// Priority status changes.
/// Upgraded to Priority
#define TICKET_PRIORITY "priority"
/// Downgraded from Priority
#define TICKET_NON_PRIORITY "non-priority"

/// Cooldowns
#define COOLDOWN_ARES_SENSOR 60 SECONDS
#define COOLDOWN_ARES_ACCESS_CONTROL 20 SECONDS
#define COOLDOWN_ARES_VENT 60 SECONDS

/// Time until someone can respawn as Working Joe
#define JOE_JOIN_DEAD_TIME (15 MINUTES)
