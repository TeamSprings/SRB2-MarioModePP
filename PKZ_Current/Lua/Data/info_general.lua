/* 
		Pipe Kingdom Zone's Mobjs - info_general.lua

Description:
Mobjinfo of objects and their states. Either Lua-fied or custom from very beginning

Contributors: Skydusk, Zipper(Bowser)
@Team Blue Spring 2024
*/

//
// Particles
//

mobjinfo[MT_DESTMARCAMERA] = {
//$Category Mario Misc
//$Name Camera destination
//$Sprite M5BLA0
	doomednum = 2462,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY
}

mobjinfo[MT_MARIOCREDSPAWN] = {
//$Category Mario Misc
//$Name CreditsSpawner
//$Sprite M5BLA0
	doomednum = 2463,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

mobjinfo[MT_MARIODOOR] = {
//$Category Mario Misc
//$Name Peach's Castle Door
//$Sprite 0MDRBL
//$Arg0 Requirement
//$Arg0Tooltip "Requirement of Dragon Coins for entrance"
	doomednum = 2560,
	spawnstate = S_MARIODOOR,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 80*FRACUNIT,
	mass = 100,
	flags = MF_SOLID|MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_MARIOSTARDOOR] = {
//$Category Mario Misc
//$Name Peach's Castle Stardoor
//$Sprite 0MDRAL
//$Arg0 Open by Key only?
//$Arg0Type 11
//$Arg0Enum noyes
//$Arg0Tooltip "Should this door open with Bone Key?"
	doomednum = 2561,
	spawnstate = S_MARIODOOR,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 48*FRACUNIT,
	height = 96*FRACUNIT,
	mass = 100,
	flags = MF_SOLID|MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_MARSKYBOXTHING] = {
//$Category Mario Misc
//$Name Mario Skybox Thing
//$Sprite TIM0A0
//$Arg0 Type of decoration
	doomednum = 2672,
	spawnstate = S_MARIOSTARDOOR,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 12*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_NOTHINK|MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_POPPARTICLEMAR] = {
	spawnstate = S_POPPARTICLEMAR,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_NOCLIPTHING|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

mobjinfo[MT_MARSMOKEPARTICLE] = {
	spawnstate = S_MARSMOKEPARTICLE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

mobjinfo[MT_PRESSUREPARTICLEMAR] = {
	spawnstate = S_PRESSUREPARTICLEMAR,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY
}

mobjinfo[MT_GOOMBAKNOCKOUT] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 8,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_SCENERY|MF_NOCLIPHEIGHT
}

//
// PKZ Enemies
//

//Bomb-Ohm 

mobjinfo[MT_BOMBOHM] = {
//$Category Mario Misc
//$Name Bomb-Ohm
//$Sprite 64BHA1
	doomednum = 2501,
	spawnstate = S_BOMBOHM1,
	spawnhealth = 1,
	reactiontime = 1,
	deathstate = S_BOMBOHMEXP,
	deathsound = sfx_mario2,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

mobjinfo[MT_MARIOOCTOPUS] = {
//$Category Mario Underwater
//$Name Blooper
//$Sprite BLOPA0
//$ParameterText Babies
	doomednum = 2401,
	spawnstate = S_MARIOOCTODADSPAWN,
	seestate = S_MARIOOCTODAD,
	deathstate = S_WELLEXCUSEMEPRINCESS,
	deathsound = SFX_MARIO2,	
	spawnhealth = 1,
	reactiontime = 35,
	speed = 8*FRACUNIT,
	radius = 12*FRACUNIT,
	height = 20*FRACUNIT,
	mass = 100,
	flags = MF_SLIDEME|MF_FLOAT|MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}


mobjinfo[MT_BULLETBILLSPAWNER] = {
//$Category Mario Castle
//$Name Bullet Bill
//$Sprite BILLA3A7
//$ParameterText Homing
//$Arg0 Toggle Tracking
//$Arg0Type 11
//$Arg0Enum falsetrue
//$Arg0Tooltip "Should spawner spawn homing missles?"
	doomednum = 2502,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY|MF_NOBLOCKMAP
}

mobjinfo[MT_BULLETBILL] = {
	spawnstate = S_BULLETBILL,
	spawnhealth = 1,
	reactiontime = 1,
	deathstate = S_EXPBULLETBILL,
	deathsound = sfx_mawii7,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

mobjinfo[MT_HOMINGBULLETBILL] = {
	spawnstate = S_HOMINGBULLETBILL,
	spawnhealth = 1,
	reactiontime = 1,
	deathstate = S_EXPBULLETBILL,
	deathsound = sfx_mario2,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

//
// PKZ Obsticles
//

mobjinfo[MT_GREYTHWOMP] = {
//$Category Mario Blocks
//$Name Grey Thwomp
//$Sprite TWU2B0
	doomednum = 2415,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY|MF_PAIN
}

mobjinfo[MT_BLUETHWOMP] = {
//$Category Mario Blocks
//$Name Blue Thwomp
//$Sprite TWU7B0
	doomednum = 2436,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_MARIOUNDERWATER] = {
//$Category Mario Underwater
//$Name SMW Floating Mine
//$Sprite MAMIA0
	doomednum = 2461,
	spawnstate = S_MARIOMINE1,
	spawnhealth = 1,
	reactiontime = 8,
	activesound = sfx_gbeeb,
	painchance = TICRATE,
	speed = 2*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = MT_UWEXPLODE,
	damage = 64*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPECIAL
}

mobjinfo[MT_GALOOMBA] = {
//$Category Mario Misc
//$Name SMW Galoomba
//$Sprite 91GAA1
	doomednum = 2620,
	spawnstate = S_GALOOMBASTILL,
	seestate = S_GALOOMBAWALK,	
	deathstate = S_GALOOMBATURNUPSIDEDOWN,
	spawnhealth = 1,
	deathsound = sfx_mario2,
	speed = 10*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

mobjinfo[MT_LAKITUS] = {
//$Category Mario Misc
//$Name Lakitus
//$Sprite 0LAKA1
	doomednum = 2621,
	spawnstate = S_LAKITUSSTILL,
	seestate = S_LAKITUSFLY,
	deathstate = S_LAKITUSDEAD,
	spawnhealth = 1,
	deathsound = sfx_mario2,
	speed = 10*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

mobjinfo[MT_BOO] = {
//$Category Mario Misc
//$Name Boo
//$Sprite 64BOA1
	doomednum = 2622,
	spawnstate = S_BOOSTILL,
	seestate = S_BOOCHARGE1,
	deathstate = S_BOODEAD,
	spawnhealth = 1,
	deathsound = sfx_mar64g,
	speed = 10*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_PAIN|MF_SPECIAL|MF_NOGRAVITY|MF_NOCLIP
}

mobjinfo[MT_DEEPCHEEP] = {
//$Category Mario Underwater
//$Name Deep Cheep
//$Sprite 1EEPA1
	doomednum = 2623,
	spawnstate = S_DEEPCHEEPROAM,
	seestate = S_DEEPCHEEPATTACK,
	deathstate = S_DEEPCHEEPDEAD,
	spawnhealth = 1,
	deathsound = sfx_mario2,
	speed = 10*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

mobjinfo[MT_MUNCHER] = {
//$Category Mario Underground
//$Name Muncher
//$Sprite 3NOMA1
	doomednum = 2624,
	spawnstate = S_MONCHER1,
	spawnhealth = 9999,
	deathsound = sfx_mario2,
	speed = 10*FRACUNIT,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_PAIN|MF_SOLID
}


//
// Bowser
//

mobjinfo[MT_BOWSER_FIRE] = {
	doomednum = -1,
	spawnstate = S_BOWSER_FIRE,
	painstate = S_BOWSER_FIRE,
	painchance = MT_FLAMEPARTICLE,
	seesound = sfx_s3kc2s,
	reactiontime = 2*TICRATE,
	deathstate = S_BOWSER_FIRE_DIE,
	spawnhealth = 1000,
	speed = 15*FRACUNIT,
	radius = 28*FRACUNIT,
	height = 68*FRACUNIT,
	flags = MF_PAIN
}

mobjinfo[MT_BOWSER_GOOMBALL] = {
	doomednum = -1,
	spawnstate = S_BOWSER_GOOMBALL,
	painstate = S_BOWSER_GOOMBALL,
	painchance = MT_GOOMBA,
	seesound = sfx_s3kc2s,
	reactiontime = 2*TICRATE,
	deathstate = S_BOWSER_GOOMBALL_DIE,
	spawnhealth = 1000,
	speed = 15*FRACUNIT,
	radius = 64*FRACUNIT,
	height = 128*FRACUNIT,
	flags = MF_PAIN
}

mobjinfo[MT_BOWSER] = {
//$Category Mario Castle
//$Name King Bowser
//$Sprite BOWSA1
	doomednum = 1715,
	spawnstate = S_BOWSER_STAND,
	painstate = S_BOWSER_FALL1,
	deathstate = S_BOWSER_FALL1,
	spawnhealth = 6,
	radius = 35*FRACUNIT,
	height = 65*FRACUNIT,
	flags = MF_SHOOTABLE|MF_BOSS|MF_SPECIAL|MF_GRENADEBOUNCE
}

// Bomb Mace used for exploading Browser's URL locator

mobjinfo[MT_BOMBMACE] = {
//$Category Mario Castle
//$Name Bomb Mace
//$Sprite BMCEA0
	doomednum = 1716,
	spawnstate = S_BOMBMACE1,
	spawnhealth = 1000,
	radius = 35*FRACUNIT,
	height = 65*FRACUNIT,
	deathsound = sfx_s3kb4,
	flags = MF_NOGRAVITY|MF_PAIN
}

//
// Interactibles/Pick-ups/Collectibles
//

// Projectiles

// Coins

// Shelmet Power-Up
// Written by SMS Alfredo

mobjinfo[MT_SHELMET] = {
//$Category Mario Pick-Ups
//$Name Shelmet
//$Sprite SHMTA1
	doomednum = 3628,
	spawnstate = S_INVISIBLE,
	deathstate = S_INVISIBLE,
	raisestate = S_INVISIBLE,
	spawnhealth = 1000,
	dispoffset = 2,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	mass = 4*FRACUNIT,
	painchance = -1,
	flags = MF_SPECIAL|MF_SCENERY
}

mobjinfo[MT_BLUECOINSPAWNER] = {
//$Category Mario Pick-Ups
//$Name Blue Coin
//$Sprite BOINA0
//$ParameterText Set
//$Arg0 Set
	doomednum = 2308,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_SPAWNERREDCOIN] = {
//$Category Mario Pick-Ups
//$Name Red Coin
//$Sprite ROINA0
//$ParameterText Set
//$Arg0 Set
	doomednum = 2504,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_REDCOINCIRCLE] = {
//$Category Mario Pick-Ups
//$Name Red Coin Circle
//$Sprite RCIRA0
//$ParameterText Set
//$Arg0 Tagged Set
	doomednum = 2503,
	spawnstate = S_REDCOINCIRCLE,
	deathstate = S_REDCOINCIRCLED,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SPECIAL|MF_PAPERCOLLISION
}

mobjinfo[MT_PKZWATERPOOLSPAWNER] = {
//$Category Mario Pick-Ups
//$Name Shelmet
//$Sprite SHMTA1
	doomednum = 2479,
	spawnstate = S_INVISIBLE,
	deathstate = S_INVISIBLE,
	raisestate = S_INVISIBLE,
	spawnhealth = 1000,
	dispoffset = 2,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	mass = 4*FRACUNIT,
	painchance = -1,
	flags = MF_SPECIAL|MF_SCENERY|MF_NOBLOCKMAP
}

mobjinfo[MT_PKZWATERPOOLCONTROLLER] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2480,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_PKZBONETRAINHEAD] = {
	//$Category Mario Castle
	//$Name Bone Train
	//$Sprite 0MGIA1
	//$Arg0 Num. of Segs
	//$Arg0Tooltip "Number of Segments of the train to spawn -- Can only be positive."
	//$Arg1 Pathway ID
	//$Arg1Tooltip "Which pathway it shall follow?"
	//$Arg2 Point ID
	//$Arg2Tooltip "Which pathway's point it should start at?"	
	//$Arg3 One-way
	//$Arg3Type 11
	//$Arg3Enum falsetrue	
	//$Arg3Tooltip "Which point it should start at?"	
	spawnstate = S_MARIOBONETRAINHEAD,
	doomednum = 2481,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 8*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
}

mobjinfo[MT_PKZBONETRAINSEG] = {
	spawnstate = S_MARIOBONETRAISEG,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 12*FRACUNIT,
	height = 16*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT|MF_SPECIAL,
}

mobjinfo[MT_BONEBOWSER] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2483,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_BANZAIBILL] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2484,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_KINGGOOMBA] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2485,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_PKZPICKVEGETABLE] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2486,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_PKZAMBIENCEOBJECT] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2488,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_PKZPOWERUPBALLOON] = {
	spawnstate = S_INVISIBLE,
	doomednum = 2489,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

// Blocks

mobjinfo[MT_QBLOCK] = {
	//$Category Mario Blocks
	//$Name Golden ?-Block
	//$Sprite M1BLA0
	//$ParameterText Reward
	//$Flags1Text Extra 16+ (Reward-Parameter)(Binary Only)
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"
	doomednum = 2412,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1
}

mobjinfo[MT_BLQBLOCK] = {
	//$Category Mario Blocks
	//$Name Cyan ?-Block
	//$Sprite M1BLA0
	//$ParameterText Reward
	//$Flags1Text Extra 16+ (Reward-Parameter)(Binary Only)
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2419,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1
}

mobjinfo[MT_GRQBLOCK] = {
	//$Category Mario Blocks
	//$Name Green ?-Block
	//$Sprite M1BLA0
	//$ParameterText Reward
	//$Flags1Text Extra 16+ (Reward-Parameter)(Binary Only)
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"
	doomednum = 2420,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1
}

mobjinfo[MT_SBQBLOCK] = {
	//$Category Mario Blocks
	//$Name Steel Blue ?-Block
	//$Sprite M1BLA0
	//$ParameterText Reward
	//$Flags1Text Extra 16+ (Reward-Parameter)(Binary Only)
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2421,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_BRQBLOCK] = {
	//$Category Mario Blocks
	//$Name Brown ?-Block
	//$Sprite M1BLA0
	//$ParameterText Reward
	//$Flags1Text Extra 16+ (Reward-Parameter)(Binary Only)
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2422,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_POWBLOCK] = {
	//$Category Mario Blocks
	//$Name POW Block
	//$Sprite C2BLA0
	doomednum = 2413,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID|MF_SCENERY|MF_PUSHABLE,
	dispoffset = -1	
}

mobjinfo[MT_NOTEBLOCK] = {
	//$Category Mario Blocks
	//$Name Note Block
	//$Sprite NO1BA0
	doomednum = 2414,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID|MF_SCENERY,
	dispoffset = -1	
}


mobjinfo[MT_MARPLATFORM] = {
	//$Category Mario Blocks
	//$Name Platform
	//$Sprite M1ATA0
	doomednum = 2416,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 128*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID|MF_SCENERY
}

mobjinfo[MT_RANDOMBLOCK] = {
	//$Category Mario Blocks
	//$Name Random Block
	//$Sprite C1BLA0
	doomednum = 2417,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID|MF_SCENERY
}

mobjinfo[MT_ICERANDOMBLOCK] = {
	//$Category Mario Blocks
	//$Name Ice Block with Item
	//$Sprite C3BLA0
	doomednum = 2418,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID|MF_SCENERY
}

mobjinfo[MT_SPRIMBRICK] = {
	//$Category Mario Blocks
	//$Name Normal Brick
	//$Sprite M5BLA0
	//$Arg0 Color
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "Brown"; 1 = "Cyan"; 2 = "Green"; 4 = "Steel Blue"; 5 = "Tan";}
	//$Arg0Tooltip "Changes Color of brick"	
	doomednum = 2460,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_QPRIMBRICK] = {
	//$Category Mario Blocks
	//$Name ?-Brown Brick
	//$Sprite M5BLA0
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2465,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_QCYANBRICK] = {
	//$Category Mario Blocks
	//$Name ?-Cyan Brick
	//$Sprite M5BLA0
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2466,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_QGREENBRICK] = {
	//$Category Mario Blocks
	//$Name ?-Green Brick
	//$Sprite M5BLA0
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2467,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_QTANBRICK] = {
	//$Category Mario Blocks
	//$Name ?-Tan Brick
	//$Sprite M5BLA0
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2468,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_QSBLBRICK] = {
	//$Category Mario Blocks
	//$Name ?-Steel Blue Brick
	//$Sprite M5BLA0
	//$Arg0 Reward
	//$Arg0Type 11
	//$Arg0Default 0
	//$Arg0Enum {0 = "1x Coin"; 18 = "3x Coin"; 19 = "10x Coin"; 14 = "Starman"; 2 = "1-UP Mushroom"; 8 = "Poison Mushroom"; 15 = "Red Mushroom"; 1 = "Fire Flower"; 17 = "Ice Flower"; 16 = "Mini Mushroom"; 12 = "Pity Mushroom"; 13 = "Pink Mushroom"; 4 = "Force Mushroom"; 5 = "Electric Mushroom"; 6 = "Elemental Mushroom"; 7 = "Whirlwind Mushroom"; 9 = "Flame Mushroom"; 10 = "Bubble Mushroom"; 11 = "Thunder Mushroom";}	
	//$Arg0Tooltip "Reward granted from the block"	
	doomednum = 2469,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

mobjinfo[MT_INFOBLOCK] = {
	//$Category Mario Blocks
	//$Name Info Block
	//$Sprite IN1BA0
	doomednum = 2470,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SOLID,
	dispoffset = -1	
}

//General PKZ Soc Info

// Invidual Pieces

mobjinfo[MT_BLOCKVIS] = {
	spawnstate = S_BLOCKQUE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 31*FRACUNIT,
	height = 63*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_AMBIENTMARIOSFX] = {
	//$Category Mario Misc
	//$Name Mario Ambiance Thing
	//$Sprite internal:ambiance
	//$Arg0 Type of Sound
	//$Arg0Type 11	
	//$Arg0Default 1
	//$Arg0Enum {1 = "Cavern"; 2 = "Desert"; 3 = "Liquid #1"; 4 = "Liquid #2"; 5 = "Liquid #3"; 6 = "Liquid #4"; 7 = "Wind"; 8 = "Lava"; 9 = "Ocean"; 10 = "Rumbling"; 10 = "Bowser's Echo"}		
	//$Arg1 Freqvency
	//$Arg1Tooltip "Freqvency of spawning in tics (1 second == 35 tics)"	
	//$Arg2 Real Radius
	//$Arg3 Easing Radius
	spawnstate = S_INVISIBLE,
	doomednum = 2478,	
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 0,
	height = 0,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SCENERY|MF_NOCLIPHEIGHT,
	dispoffset = 2
}

mobjinfo[MT_WIDEWINGS] = {
	spawnstate = S_WIDEWINGS,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 1*FRACUNIT,
	height = 1*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY
}

mobjinfo[MT_CUTSCENEJUNKMARIO] = {
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 1*FRACUNIT,
	height = 1*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SCENERY,
	dispoffset = -1
}

mobjinfo[MT_ITEMHOLDERBALLOON] = {
	spawnstate = S_ITEMHOLDERBALLOON,
	spawnhealth = 1,
	reactiontime = 1,
	speed = 12,
	radius = 22*FRACUNIT,
	height = 55*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_SPECIAL|MF_SCENERY,
}