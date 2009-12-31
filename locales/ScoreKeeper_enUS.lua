setfenv(1, ScoreKeeper)
Locales.enUS = {
	['Uknown'] = 'Uknown',
	genders = {
		['Male'] = 'Male',
		['Female'] = 'Female'
	},
	commandDescription = {
		help = {'- get command list.', '<command> - Get information on how to use command.'},
		lookup = 'or /skl <name[-realm]> - Lookup character in ScoreKeeper database.',
		purge = '- Reset Scorekeeper database.'
	},
	commandHelp = {
		lookup = 'Usage example: /skl Logistic-Mal\'Ganis\nCase-insensitive and punctuation-insensitive so "/skl logistic-malganis" would also work.'
	}
}