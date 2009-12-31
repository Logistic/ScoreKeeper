setfenv(1, ScoreKeeper)
commands = {}
commandHelp = {}
commandDescription = {}

addInit(function()
	_G.SLASH_SCOREKEEPER1 = '/scorekeeper'
	_G.SLASH_SCOREKEEPER2 = '/sk'
	_G.SLASH_SCOREKEEPER_LOOKUP1 = '/skl'
	_G.SlashCmdList['SCOREKEEPER'] = commandHandler
	_G.SlashCmdList['SCOREKEEPER_LOOKUP'] = lookupCommandHandler
end)

function runCommand(command, args)
	command = strlower(strtrim(command or ''))
	args = args or ''
	local commandFunction = commands[command]
	if type(commandFunction) == 'function' then
		commandFunction(args)
	else
		print('ScoreKeeper: Command "' .. command .. '" not found. Type /sk help for a list of commands.')
	end
end

function commandHandler(message, editbox)
	local command, args = message:match("^(%S+)%s?(.*)$");
	runCommand(command, args)
end

function lookupCommandHandler(args, editbox)
	runCommand('lookup', args)
end

do
	local function printDescription(command, description)
		if description then
			local prefix = '/sk ' .. command
			if type(description) == 'table' then
				for _, subDescription in pairs(description) do
					print(prefix, subDescription)
				end
			else
				print(prefix, description)
			end
		end
	end
	function commands.help(args)
		local command = strlower(strtrim(args))
		local help = Localization:getCommandHelp(command)
		local description = Localization:getCommandDescription(command)
		printDescription(command, description)
		if help then
			print(help)
		elseif not description then
			for otherCommand, otherFunction in pairs(commands) do
				local otherDescription = Localization:getCommandDescription(otherCommand)
				if otherDescription then
					printDescription(otherCommand, otherDescription)
				end
			end
		end
	end
end

function commands.lookup(args)
	local name, realm = strsplit('-', strtrim(args))
	local character, name, realm = Database:getCharacterLooseMatch(name, realm)
	if character then
		Ui:inspectCharacter(character, name, realm)
	elseif not name or name == '' then
		Ui:showPlayer()
	else
		print('Could not find character', name, 'of realm', realm, 'in ScoreKeeper database')
	end
end
commands.l = commands.lookup

function commands.purge(args)
	resetDatabase()
end