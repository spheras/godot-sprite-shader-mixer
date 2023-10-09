class_name  Util
extends Object

# Read a file and return the content of it
#  filePath -> the absolute path
#  return -> the file content
static func readFile(filePath:String)->String:
	if(!FileAccess.file_exists(filePath)):
		return ""

	var file=FileAccess.open(filePath, FileAccess.READ)
	var content=file.get_as_text()
	file.close()
	return content

# Delete a file on the filesystem
#   filePath -> the aboslute path
static func deleteFile(filePath:String):
	DirAccess.remove_absolute(filePath)


# Save content to a file
#   filePath -> the aboslute path
#   content -> the content to store inside
static func saveFile(filePath:String, content:String):
	var file=FileAccess.open(filePath, FileAccess.WRITE)
	file.store_string(content)
	file.close()	

# Save content binary to a file
#   filePath -> the aboslute path
#   content -> the content to store inside
static func saveBinaryFile(filePath:String, content:PackedByteArray):
	var file=FileAccess.open(filePath, FileAccess.WRITE)
	file.store_buffer(content)
	file.close()

# Read a JSON file and return the conent of it as a Variant
#  filePath -> the absolute path
#  return -> the json file content parsed as generic object
static func readJsonFile(filePath:String)->Variant:
	var file = FileAccess.open(filePath, FileAccess.READ)
	if(file!=null):
		var content:String = file.get_as_text()
		return JSON.parse_string(content)
	return null
	
