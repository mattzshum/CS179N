extends Node
var level = 0
func set_level(level):
	self.level = level
func inc_level():
	level += 1
	return level < 5
enum HeroTypes {
	asteria,
	astroknight,
	lune,
	starman
}

var records = {
	DifficultyModes.Easy: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	},
	DifficultyModes.Medium: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	},
	DifficultyModes.Hard: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	}
}

func desc(heroName, primary, secondary):
	return "%s\n\n[X] %s\n[Z] %s" % [heroName, primary, secondary]
var heroDesc = {
	HeroTypes.starman: desc("Starman", "Laser Cannons", "Shooting Star"),
	HeroTypes.asteria: desc("Asteria", "Plasma Thrower", "Star Burst"),
	HeroTypes.astroknight: desc("Astroknight", "Steel Bolt", "Solar Saber"),
	HeroTypes.lune: desc("Lune", "Crescent Beam", "Moon Blast")
}

var hero = HeroTypes.starman
func setHero(h):
	hero = h
func set_winner(w):
	winner = w
var winner = true
var totalScore = 0
var totalTime = 0
func reset():
	level = 0
	winner = true
	totalScore = 0
	totalTime = 0

enum DifficultyModes {
	Easy, Medium, Hard
}
var difficulty = DifficultyModes.Medium
