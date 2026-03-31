extends Node

@export var charSheet:Container
@export var createCharSheet:Container


func _ready() -> void:
	#setup listeners
	createCharSheet.submitCharButton.pressed.connect(onCharacterSubmitButtonPressed)

	#testing stuff
	var testSkill = SkillData.new("Lmao")
	testSkill.setLevel(1)
	var testString = testSkill.stringify()
	print(testString)
	var testSkill2 = SkillData.new("")
	testSkill2.copyFromString(testString)
	#testSkill2.lmao()

func onCharacterSubmitButtonPressed():
	#grab all attributes from char sheet
	var charName = createCharSheet.nameField.text
	var newChar = CharacterData.new(charName)

	#get all data from skill panel
	for i in range(createCharSheet.skillInputList.size()):
		var currentPanel = createCharSheet.skillInputList[i]

		#needa game name first for skill constructor
		var newName = ""
		if currentPanel.nameInput.text == "" || currentPanel.nameInput.text == " ":
			newName = CN.DEAD_SKILL_NAME
		else:
			newName = currentPanel.nameInput.text

		var newSkill = SkillData.new(str(newName))
		print("SKill " + str(i) + " name is: " + str(newSkill.name))

		if newSkill.deadSkill:
			#print("Passed index [" + str(i) + "]")
			continue
		

		newSkill.setLevel(int(currentPanel.levelField.text))
		newSkill.setTimesUsed(int(currentPanel.usedField.text))
		newSkill.setRank(currentPanel.rankField.activeRank)

		newChar.addSkill(i,newSkill)	

	CN.active_character_changed.emit(newChar)

	#change screen to charSheet
	charSheet.visible = true
	
