local dir

dir = 'entities'

tbsmacroinit(dir, 'decor',
	'common'
)

tbsmacroinit(dir, 'entity',
	--'common',
	'helpers'
)

tbsmacroinit(dir, 'model',
	'common'
)

dir = 'entities/foes'

tbsmacroinit(dir, 'foe',
	'blooper',
	'bomb_ohm',
	'boo',
	'bowserjr',
	'bulletbill',
	'galoomba',
	'goomba',
	'koopa',
	'misc',
	'piranha'
)

dir = 'entities/items'

tbsmacroinit(dir, 'item',
	'checkpoint',
	'coins',
	'key',
	'mushroom',
	'powermoon',
	'shelmet',
	'specialcoins',
	'starman'
)

dir = 'entities/bowser'

tbsmacroinit(dir, 'bow',
	'helpers',
	'main',
	'otherthink',
	'dry'
)

dir = 'entities/map'

tbsmacroinit(dir, 'const',
	'ambience',
	'pathing'
)

tbsmacroinit(dir, 'map',
	'exec'
)