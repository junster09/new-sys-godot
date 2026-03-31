extends Node

#to call from this, use "CN"

const CHAR_DEFAULT_SKILL_LIMIT = 10
const CHAR_DEFAULT_FATE_POINTS = 2

#DICE
const PREPARED_DICE_MINIMUM = 3
const DAZED_DICE_MAXIMUM = 3

enum DICE_TYPE {
	COMBAT,
	NON_COMBAT,
	PREPARED,
	DAZED,
	DAZED_PREPARED
}

var DICE_TYPE_COUNT = {
	DICE_TYPE.COMBAT: 5,
	DICE_TYPE.NON_COMBAT: 10,
	DICE_TYPE.PREPARED : 5,
	DICE_TYPE.DAZED : 5,
	DICE_TYPE.DAZED_PREPARED : 5
}

var DICE_STRING = {
	DICE_TYPE.COMBAT: "d5",
	DICE_TYPE.NON_COMBAT: "d10!",
	DICE_TYPE.PREPARED : "d5",
	DICE_TYPE.DAZED : "d5",
	DICE_TYPE.DAZED_PREPARED : "3"
}

#CONSEQUENCE
enum CONSEQUENCE_TYPE {
	TEMPORARY,
	MILD,
	MODERATE,
	SEVERE,
	EXTREME,
	FATE_ALTERING
}

const CONSEQUENCE_TYPE_STRING = {
	CONSEQUENCE_TYPE.TEMPORARY : "Temporary",
	CONSEQUENCE_TYPE.MILD : "Mild",
	CONSEQUENCE_TYPE.MODERATE : "Moderate",
	CONSEQUENCE_TYPE.SEVERE : "Severe",
	CONSEQUENCE_TYPE.EXTREME : "Extreme",
	CONSEQUENCE_TYPE.FATE_ALTERING : "Fate Altering",
}

#SKILL
const DEAD_SKILL_NAME = "%!_N0_5K177" #specific skill name

enum SKILL_RANK_BY_NAME {
	UNK,
	TIN,
	BRONZE,
	SILVER,
	GOLD
}
var SKILL_RANK_DETAILS = {
	SKILL_RANK_BY_NAME.UNK: SkillRank.new("UNK","#ffffff",9999),
	SKILL_RANK_BY_NAME.TIN:SkillRank.new("Tin","#b36e00",5),
	SKILL_RANK_BY_NAME.BRONZE:SkillRank.new("Bronze","#b36e00",10),
	SKILL_RANK_BY_NAME.SILVER:SkillRank.new("Silver","#a8a8a8",20),
	SKILL_RANK_BY_NAME.GOLD:SkillRank.new("Gold","#ffe882",30)
}

func isValidSkillRank(_rank) -> bool:
	if(_rank < 0 || (_rank > SKILL_RANK_DETAILS.size())):
		return false
	else:
		return true

func getSkillRankDetails(_rank) -> SkillRank:
	if(_rank < 0):
		_rank = 0
	elif(_rank > SKILL_RANK_DETAILS.size()):
		_rank = 0

	return SKILL_RANK_DETAILS[_rank]

#STRESS
enum STRESS_STATE{
	NORMAL,
	STAGGERED,
	DAMAGED
}

const STRESS_COLORS ={
	STRESS_STATE.NORMAL:Color("00a53a64"),
	STRESS_STATE.STAGGERED:Color("f3ac0096"),
	STRESS_STATE.DAMAGED:Color("ff312196")
}

#Roll Format

#Output code should consist of 3 things:
	#the Header: &{template:default}{{name= PURPLE_HEADER_TEXT}}
	#the roll: {total= [[ all the roll code goes here]]}
	#the display refrences: {SKILL_NAME: $[[index]]}

	# Header + roll + "]]}}" + display refrence

func getRollHeader(_charName:String) -> String:
	return ("&{template:default}{{name=" + _charName + "}}{{Total=[[ ")

func getBaseRoll(_type:int) -> String:
	var rollCode:String = ""

	match _type:
		DICE_TYPE.COMBAT:
			rollCode = " [[2d5]][base] "
		DICE_TYPE.NON_COMBAT:
			rollCode = " [[1d10!]][base]"
		DICE_TYPE.PREPARED:
			rollCode = " [[{{2d5},0d0+6}kh1]][base]"
		DICE_TYPE.DAZED:
			rollCode = " [[{{2d5},0d0+6}kl1]][base]"
		DICE_TYPE.DAZED_PREPARED:
			rollCode = " [[2*3]][base]"
		_:
			rollCode = ""
	return rollCode

func getRemainingDiceCode(_remain:int) -> String:
	match _remain:
		0:
			return ""
		1:
			return "1"
		_:
			return "1d" + str(_remain)

func getSkillRoll(_skill:SkillData,_diceType:int) -> String:
	var rollCode:String = ""
	var rollingDice:int = floor(_skill.getLevel()/DICE_TYPE_COUNT[_diceType])
	var rollRemain:int = _skill.getLevel()%DICE_TYPE_COUNT[_diceType]

	if rollingDice > 0:
		rollCode += " + [["
		match _diceType:
			DICE_TYPE.PREPARED: #prepared has a special syntax ({{rollingDice d5},0d0+MIN}kh1) + remaining
				rollCode += "({{" + str(rollingDice) + DICE_STRING[_diceType] + "},0d0+" + str(PREPARED_DICE_MINIMUM * rollingDice) + "}kh1)"
			DICE_TYPE.DAZED: #dazed roll also has a special syntax ({{rollingDice d5},0d0+MIN}kl1) + remain
				rollCode += "({{" + str(rollingDice) + DICE_STRING[_diceType] + "},0d0+" + str(DAZED_DICE_MAXIMUM * rollingDice) + "}kl1)"
			DICE_TYPE.DAZED_PREPARED: #dazed and prepped has a funny syntax [[rollingDice * 3]]
				rollCode += str(rollingDice * PREPARED_DICE_MINIMUM)
			_:
				rollCode += "(" + str(rollingDice) + DICE_STRING[_diceType] + ")"
	
	#format for writing things that are less than Xd5 + XdX
	if rollingDice > 0 && rollRemain != 0: #at thsi point, the "Xd5" has been written, this is just the XdX part
		rollCode += " + (" + getRemainingDiceCode(rollRemain) + ")";
	elif rollRemain != 0: #case for no Xd5 + XdX, it's just [[XdX]]
		rollCode += " + [[" + getRemainingDiceCode(rollRemain)

	#close brackets
	if rollingDice != 0 || rollRemain != 0:
		rollCode += "]]"
	
	rollCode += "[" + _skill.name + "]"
	return rollCode

func formatArbitraryCode(_input) -> String:
	#Read code for the following:
	# + at the start
	# - at the start
	# [BLANK] at the start

	var outputCode = ""

	if not _input:
		return outputCode

	var firstInput = _input.substr(0,1)

	if firstInput == "-":
		outputCode = " - [[(" + _input.substr(1,-1) + ")]][Arbitrary]"
	else:
		outputCode = " + [[(" + _input.substr(1,-1) + ")]][Arbitrary]"

	return outputCode

#FILE IO
const ATTRIBUTE_DELIMITER = "/|/"
const CLASS_DELIMITER = "+!="

enum SKILL_DATA_ARRAY{NAME,RANK,LEVEL,USED,DEAD}

#Signals
signal active_character_changed(_newChar:CharacterData)
