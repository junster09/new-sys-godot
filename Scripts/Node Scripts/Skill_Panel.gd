extends Panel

@export var skillNameText :Label
@export var skillRankText :Label
@export var skillLevelText :Label
@export var skillLevelButton :Button
@export var skillTimesUsedText :Label
@export var skillUsedButton :Button

var activeSkill:SkillData

func updateData():
    if activeSkill == null:
        pass
        
    print(activeSkill.name)
    skillNameText.text = activeSkill.name
    skillRankText.text = CN.SKILL_RANK_DETAILS[activeSkill.rank].name
    skillLevelText.text = str(activeSkill.level)
    skillTimesUsedText.text = str(activeSkill.timesUsedSinceLastLevel)

func setSkillData(_skill:SkillData):
    activeSkill = _skill
    
    if not activeSkill.deadSkill:
        updateData()
        self.visible = true
    else:
        self.visible = false