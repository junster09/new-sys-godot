extends MarginContainer

@export var rollStyleContainer :MenuButton
@export var arbRollCodeInput :LineEdit
@export var arbRollSubmitButton :Button
@export var outputCodeContainer :TextEdit
@export var copyCodeButton :Button
@export var skillButtonContainer :Container

@export var skillButtons :Array[Button]

var activeCharacter:CharacterData
var skillPerRow = 5

func formatSkillRow(_row:Container):
	_row.size_flags_horizontal = 3
	_row.size_flags_vertical = 3

func createNewSkillButton() -> Button:
	var newSkillButton = Button.new()
	newSkillButton.size_flags_horizontal = 3
	newSkillButton.size_flags_vertical = 3
	newSkillButton.text = "SKILL"
	newSkillButton.toggle_mode = true
	#newSkillButton.visible = false
	return newSkillButton

func onActiveCharacterChanged(_newChar:CharacterData):
	print("onActiveCharacter: Skill_roll")
	activeCharacter = _newChar
	var skills = activeCharacter.skills

	if skills.size() > skillButtons.size():
		skillButtons.resize(skills.size())

	for i in range(skills.size()):
		print("Skill at [" + str(i) + "] is: " + skills[i].name)
		if not skills[i].deadSkill:
			skillButtons[i].text = skills[i].name
			skillButtons[i].visible = true
		else:
			skillButtons[i].visible = false

func updateOutput():
	if activeCharacter == null: return
	var displayCode:String = " {{BASE = $[[0]]}} "
	var rollCode:String = ""
	var rollStyle = rollStyleContainer.activeRank

	rollCode += CN.getBaseRoll(rollStyle)

	var rollIndex = 0 #this is for displayCode

	for i in range(skillButtons.size()):
		if not skillButtons[i].button_pressed: continue
		if activeCharacter.skills[i].deadSkill: continue
		rollCode += CN.getSkillRoll(activeCharacter.skills[i],rollStyle)
		rollIndex += 1
		displayCode += "{{" + str(activeCharacter.skills[i].name) + " = $[[" + str(rollIndex) + "]]}}" 
	
	var arb = str(arbRollCodeInput.text)
	if arb:
		arb = CN.formatArbitraryCode(arb)
		rollCode += arb
		displayCode += " {{Arbitrary= $[[" + str(rollIndex + 1) + "]]}}"

	outputCodeContainer.text = CN.getRollHeader(activeCharacter.name) + rollCode + " ]]}} " + displayCode

func onCopyCodePressed():
	DisplayServer.clipboard_set(outputCodeContainer.text)


func _ready() -> void:
	#create listeners
	CN.active_character_changed.connect(onActiveCharacterChanged)
	copyCodeButton.pressed.connect(onCopyCodePressed)
	arbRollSubmitButton.pressed.connect(updateOutput)

	#figure out how many rows we need
	var rowCount = CN.CHAR_DEFAULT_SKILL_LIMIT/skillPerRow
	var remainingSkills = CN.CHAR_DEFAULT_SKILL_LIMIT%skillPerRow

	if remainingSkills > 0:
		rowCount +=1

	skillButtons.resize(CN.CHAR_DEFAULT_SKILL_LIMIT)

	#make rows first
	for i in range(rowCount):
		var newRow = HBoxContainer.new()
		formatSkillRow(newRow)
		skillButtonContainer.add_child(newRow)

		#figure out how many skills we have left
		var skillsInThisRow :int
		if (i+1)*skillPerRow <= CN.CHAR_DEFAULT_SKILL_LIMIT:
			skillsInThisRow = skillPerRow
		else:
			skillsInThisRow = remainingSkills

		#make buttons
		for j in range(skillsInThisRow):
			var skillIndex = (i*skillsInThisRow) + j
			var newSkillButton = createNewSkillButton()
			skillButtons[skillIndex] = newSkillButton
			newSkillButton.name = "Skill Button " + str(skillIndex)
			newRow.add_child(newSkillButton)

			#could add button listener here
			newSkillButton.pressed.connect(updateOutput)
