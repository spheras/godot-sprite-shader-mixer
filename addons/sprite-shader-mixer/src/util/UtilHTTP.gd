class_name  UtilHTTP
extends Object

static func httpsDownloadJson(host:String, url:String)->String:
		var byteArray = await httpsDownloadBinary(host, url)
		return byteArray.get_string_from_ascii()
	
static func httpsDownloadBinary(host:String, url:String)->PackedByteArray:
	var err = 0
	var http = HTTPClient.new() # Create the Client.
	var tls=TLSOptions.client()
	err = http.connect_to_host(host, 443, tls) # Connect to host/port.
	assert(err == OK) # Make sure connection is OK.

	# Wait until resolved and connected.
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		#print("Connecting...")
		if not OS.has_feature("web"):
			OS.delay_msec(500)
		else:
			await Engine.get_main_loop()

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Check if the connection was made successfully.

	# Some headers
	var headers = [
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]

	err = http.request(HTTPClient.METHOD_GET, url, headers) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK.

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		#print("Requesting...")
		if OS.has_feature("web"):
			# Synchronous HTTP requests are not supported on the web,
			# so wait for the next main loop iteration.
			await Engine.get_main_loop()
		else:
			OS.delay_msec(500)

	#print_debug("status:",http.get_status())
	assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

	#print("response? ", http.has_response()) # Site might not have a response.

	if http.has_response():
		# If there is a response...

		headers = http.get_response_headers_as_dictionary() # Get response headers.
		#print("code: ", http.get_response_code()) # Show response code.
		#print("**headers:\\n", headers) # Show headers.

		# Getting the HTTP Body

		if http.is_response_chunked():
			# Does it use chunks?
			#print("Response is Chunked!")
			pass
		else:
			# Or just plain Content-Length
			var bl = http.get_response_body_length()
			#print("Response Length: ", bl)

		# This method works for both anyway

		var rb = PackedByteArray() # Array that will hold the data.

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				if not OS.has_feature("web"):
					# Got nothing, wait for buffers to fill a bit.
					OS.delay_usec(1000)
				else:
					await Engine.get_main_loop()
			else:
				rb = rb + chunk # Append to read buffer.
		# Done!

		return rb
	return PackedByteArray()
