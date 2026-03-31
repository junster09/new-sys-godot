class_name SkillData


var name: String = ""
var rank: int = CN.SKILL_RANK_BY_NAME.UNK
var level: int = 0
var timesUsedSinceLastLevel: int = 0
var deadSkill: bool = false

func _init(_name:String) -> void:
	if _name == CN.DEAD_SKILL_NAME:
		kill()
	else:
		name = _name

func setAll(_name,_rank,_level,_timesUsed) -> bool:
	name = _name
	setRank(_rank)
	setLevel(_level)
	setTimesUsed(_timesUsed)
	return true

func getRank() -> int: return rank

func setRank(_rank) -> bool:
	if(CN.isValidSkillRank(_rank)):
		rank = _rank
		return true
	else:
		rank = 0
		return false

func getLevel() -> int: return level

func setLevel(_level) -> bool:
	if(_level > CN.SKILL_RANK_DETAILS[rank].maxLevel):
		level = level%CN.SKILL_RANK_DETAILS[rank].maxLevel
		level = setRank(rank + 1)
	else:
		level = _level
	return true

func getTimesUsed() -> int: return timesUsedSinceLastLevel
func setTimesUsed(_timesUsed) -> bool: timesUsedSinceLastLevel = _timesUsed; return true

func kill() -> void:
	name = CN.DEAD_SKILL_NAME
	rank = CN.SKILL_RANK_BY_NAME.UNK
	level = -99
	timesUsedSinceLastLevel = -9999
	deadSkill = true

func revive() -> void:
	name = ""
	rank = CN.SKILL_RANK_BY_NAME.UNK
	level = 0
	timesUsedSinceLastLevel = 0
	deadSkill = false

func copySkill(_targetSkill: SkillData) -> bool:
	name = _targetSkill.name
	rank = _targetSkill.rank
	level = _targetSkill.level
	timesUsedSinceLastLevel = _targetSkill.timesUsedSinceLastLevel
	deadSkill = _targetSkill.deadSkill
	return true

func stringify() -> String:
	var stringedCode:String = ""

	if deadSkill:
		return CN.DEAD_SKILL_NAME

	var dataArray:Array[String]
	dataArray.resize(CN.SKILL_DATA_ARRAY.size())
	dataArray[CN.SKILL_DATA_ARRAY.NAME] = str(name)
	dataArray[CN.SKILL_DATA_ARRAY.RANK] = str(rank)
	dataArray[CN.SKILL_DATA_ARRAY.LEVEL] = str(level)
	dataArray[CN.SKILL_DATA_ARRAY.USED] = str(timesUsedSinceLastLevel)
	dataArray[CN.SKILL_DATA_ARRAY.DEAD] = str(deadSkill)

	for i in dataArray:
		stringedCode += i + CN.ATTRIBUTE_DELIMITER

	return stringedCode

func copyFromString(_skillString:String) -> void:
	var dataArray:Array[String]
	dataArray.resize(CN.SKILL_DATA_ARRAY.size())

	for i in (_skillString.get_slice_count(CN.ATTRIBUTE_DELIMITER) -1):
		dataArray[i] = _skillString.get_slice(CN.ATTRIBUTE_DELIMITER,i)
	
	name = str(dataArray[CN.SKILL_DATA_ARRAY.NAME])
	if name == CN.DEAD_SKILL_NAME:
		return 

	rank = int(dataArray[CN.SKILL_DATA_ARRAY.RANK])
	level = int(dataArray[CN.SKILL_DATA_ARRAY.LEVEL])
	timesUsedSinceLastLevel = int(dataArray[CN.SKILL_DATA_ARRAY.USED])


	
