#ifdef SS13LIB_ATTEST_DOMAIN

#define SS13LIB_ED25519_SIGNATURE_BASE64_LENGTH 88

/datum/ss13lib/proc/perform_attestation()
	if(!src.server_id || !src.nonce)
		SS13LIB_WARNING_LOG("Cannot attest: missing server_id or nonce.")
		return FALSE

	var/timestamp = SS13LIB_UNIX_EPOCH
	var/message = "[src.server_id]:[src.nonce]:[timestamp]"
	var/signature = SS13LIB_ED25519_SIGN(SS13LIB_ATTEST_PRIVKEY, message)

	if(!signature || length(signature) != SS13LIB_ED25519_SIGNATURE_BASE64_LENGTH)
		SS13LIB_WARNING_LOG("Attestation signing failed: [signature]")
		return FALSE

	var/datum/ss13lib_http_response/response = perform_http_request(
		SS13LIB_HTTP_POST,
		"[SS13LIB_HUB_SERVER]/attest",
		list(
			"server_id" = src.server_id,
			"domain" = SS13LIB_ATTEST_DOMAIN,
			"timestamp" = timestamp,
			"signature" = signature,
		)
	)

	if(response.errored)
		SS13LIB_WARNING_LOG("Attestation request failed.")
		return FALSE

	var/body
	try
		body = json_decode(response.body)
	catch
		SS13LIB_WARNING_LOG("Could not decode attestation response.")
		return FALSE

	if(body && body["verified_domain"])
		SS13LIB_INFO_LOG("Domain attestation successful: [body["verified_domain"]]")
		return TRUE

	SS13LIB_WARNING_LOG("Attestation rejected by hub.")
	return FALSE

#undef SS13LIB_ED25519_SIGNATURE_BASE64_LENGTH
#endif
