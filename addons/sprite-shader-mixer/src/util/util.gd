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

# Read a JSON file and return the conent of it as a Variant
#  filePath -> the absolute path
#  return -> the json file content parsed as generic object
static func readJsonFile(filePath:String)->Variant:
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content:String = file.get_as_text()
	return JSON.parse_string(content)
