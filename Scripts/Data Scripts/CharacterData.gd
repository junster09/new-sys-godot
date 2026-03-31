class_name CharacterData 

var name: String = ""
var skills: Array[SkillData]
var skillLimit = CN.CHAR_DEFAULT_SKILL_LIMIT

# 0 off, 1 is stagger, 2 is damage
var stressBoxes = [0,0,0,0]
#make consequence class later
var consequences = []

var maxFatePoints = CN.CHAR_DEFAULT_FATE_POINTS
var currentFatePoints = maxFatePoints

var notes = ""

func _init(_name: String) -> void:
	name = _name

	skills.resize(skillLimit)
	#make skill limit dead skills by default
	for i in range(skillLimit):
		skills[i] = SkillData.new(CN.DEAD_SKILL_NAME)

	consequences.resize(4)
	for i in range(consequences.size()):
		consequences[i] = ConsequenceData.new(CN.DEAD_SKILL_NAME,0,0,0)

func addSkill(_skillSlot: int, _skill: SkillData) -> bool:
	if(_skillSlot <= skillLimit):
		skills[(_skillSlot)] = _skill
		return true
	else:
		return false

func getSkill(_skillSlot: int) -> SkillData:
	if _skillSlot >= skills.size() || _skillSlot < 0:
		return null
	else:
		return skills[_skillSlot]

#not really a "clear" more like a "reset"
func clearSkill(_skillSlot: int) -> bool:
	if _skillSlot >= skills.size() || _skillSlot < 0:
		return false
	else:
		skills[_skillSlot].kill()
		return true
		
func replaceSkillList(_skillList) -> bool:
	for i in range(_skillList.size()):
		skills[i] = _skillList[i]
	
	return true

func overwriteCharacterFromObject(_newChar: CharacterData) -> bool:
	name = _newChar.name
	skillLimit = _newChar.skillLimit
	stressBoxes = _newChar.stressBoxes
	consequences = _newChar.consequences
	maxFatePoints = _newChar.maxFatePoints
	currentFatePoints = _newChar.currentFatePoints
	replaceSkillList(_newChar.skills)

	return true

func getStressBox(_pos) -> int:
	if _pos >= stressBoxes.size() || _pos < 0:
		return -1
	else:
		return stressBoxes[_pos]
	
func setStressBoxes(_pos,_state) -> bool:
	var box = getStressBox(_pos)
	if box > -1:
		stressBoxes[_pos] = _state
		return true
	else:
		return false

func incrementSkillUsage(_skillSlot,_amount):
	var selectedSkill = getSkill(_skillSlot)
	if selectedSkill == null:
		return
	else:
		selectedSkill.setTimesUsed(selectedSkill.getTimesUsed() + 1)
