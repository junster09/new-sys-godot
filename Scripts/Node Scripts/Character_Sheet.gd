extends MarginContainer

@export var charNameText: Label
@export var skillListContainer: Container
@export var stressButtons: Array[Button]
@export var stressBoxes: Array[ColorRect]

var skillPanel = preload(UD.PANELS.SKILL_PANEL)

var activeCharacter:CharacterData
var skillListArray: Array[Panel]


func stressButtonPressed(_buttonIndex):
	if activeCharacter == null:
		return

	var stressCurState = activeCharacter.getStressBox(_buttonIndex)
	stressCurState = (stressCurState + 1)%CN.STRESS_STATE.size()

	var stressColor = CN.STRESS_COLORS[stressCurState]
	stressBoxes[_buttonIndex].color = stressColor

	activeCharacter.setStressBoxes(_buttonIndex,stressCurState)
	
func updateSkillDisplay():
	for sp in skillListArray:
		sp.updateData()

func updateConsequenceDisplay():
	pass

func updateStressBoxDisplay():
	for i in range(stressBoxes.size()):
		var stressCurState = activeCharacter.getStressBox(i)
		stressBoxes[i].color = CN.STRESS_COLORS[stressCurState]

func updateCharacterDisplay():
	charNameText.text = activeCharacter.name

	for i in range(activeCharacter.skills.size()):
		skillListArray[i].setSkillData(activeCharacter.getSkill(i))

	updateSkillDisplay()
	updateStressBoxDisplay()

func onActiveCharacterChanged(_newChar:CharacterData):
	activeCharacter = _newChar
	updateCharacterDisplay()

func _ready() -> void:
	#setup listeners

	#listeners for stress buttons
	for i in range(stressButtons.size()):
		stressButtons[i].pressed.connect(func():stressButtonPressed(i)) #this is very Core-coded :sunglasses:

	#listener for character changed
	CN.active_character_changed.connect(onActiveCharacterChanged)

	for i in range(CN.CHAR_DEFAULT_SKILL_LIMIT):
		var panel = skillPanel.instantiate()
		skillListContainer.add_child(panel)
		skillListArray.append(panel) #pray to god(ot) that it's in order
		panel.visible = false
