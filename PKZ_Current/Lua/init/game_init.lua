local dir

dir = 'game'

tbsmacroinit(dir, 'scenes',
	'common'
)

tbsmacroinit(dir, 'powers',
	'common',
	'backuppw'
)


tbsmacroinit(dir, 'modes',
	'common'
)

dir = 'game/modes'

--tbsmacroinit(dir, 'mode',
--	'racing'
--)

dir = 'game/scenes'

tbsmacroinit(dir, 'scenes',
	'credits',
	'flagpole',
	'intros'
)