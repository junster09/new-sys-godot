class_name CharacterSave extends Node


enum SAVE_ORDER {
	NAME,
	SKILLS,
	SKILL_LIMIT,
	STRESS,
	CONSEQUENCES,
	MAX_FATE_POINTS,
	CURRENT_FATE_POINTS,
	NOTES
}

func packSkills(_skillList:Array[SkillData]) -> String:
	var packString = ""
	for i in range(_skillList.size()):
		packString += _skillList[i].stringify() + CN.CLASS_DELIMITER
	return packString
	
func unpackSkills(_packedSkillList:String) -> Array[SkillData]:
	var skillArray:Array[SkillData]
	#var slicedString:Array
	var skillsCount = _packedSkillList.get_slice_count(CN.CLASS_DELIMITER)
	skillArray.resize(skillsCount)

	for i in range(skillsCount - 1):
		var packedSkill = _packedSkillList.get_slice(CN.CLASS_DELIMITER,i)
		var newSkill = SkillData.new("")
		newSkill.copyFromString(packedSkill)
		skillArray[i] = newSkill
		
		

	return skillArray
	
func packStress(_stress:Array[int]) -> String:
	var stressString = ""
	for i in _stress:
		stressString += str(i)
	
	return stressString

func unpackStress(_stressString:String) -> Array[int]:
	var stressArray:Array[int]
	stressArray.resize(_stressString.length())

	for i in range(stressArray.size()):
		stressArray[i] = int(_stressString[i])

	return stressArray
	



func createCharSave(_char:CharacterData) -> PackedStringArray:
	#untyped array ftw
	var saveArray:Array = []
	saveArray.resize(SAVE_ORDER.size())
	
	saveArray[SAVE_ORDER.NAME] = _char.name
	saveArray[SAVE_ORDER.SKILLS] = packSkills(_char.skills)
	saveArray[SAVE_ORDER.SKILL_LIMIT] = _char.skillLimit
	saveArray[SAVE_ORDER.STRESS] = packStress(_char.stressBoxes)
	saveArray[SAVE_ORDER.CONSEQUENCES] = _char.consequences
	saveArray[SAVE_ORDER.MAX_FATE_POINTS] = _char.maxFatePoints
	saveArray[SAVE_ORDER.CURRENT_FATE_POINTS] = _char.currentFatePoints
	saveArray[SAVE_ORDER.NOTES] = _char.notes

	var save:PackedStringArray = PackedStringArray(saveArray)
	return save

func loadCharSave(_save:PackedStringArray) -> CharacterData:
	var loadChar:CharacterData = CharacterData.new("")


	return loadChar

func _init() -> void:
	pass
