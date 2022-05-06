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

func desc(heroName, primary, secondary):
	return heroName + "\n\n" + "[X] " + primary + "\n" + "[Z] " + secondary
var heroDesc = {
	HeroTypes.starman: desc("Starman", "Laser Cannons", "Shooting Star"),
	HeroTypes.asteria: desc("Asteria", "Plasma Thrower", "Star Burst"),
	HeroTypes.astroknight: desc("Astroknight", "Blade Beam", "Solar Saber"),
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
	winner = true
	totalScore = 0
	totalTime = 0
