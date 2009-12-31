setfenv(1, ScoreKeeper)
DatabaseObject = {}

addInit(function()
	Object.setup(DatabaseObject)
end)

function DatabaseObject:new(new)
	new = self.parent.new(self, new)
	if not new.characters then
		new.characters = {}
	end
	return new
end

function DatabaseObject:clone(clone)
	clone = self.parent.clone(self, clone)
	
	clone.characters = Functions.table.deepcopy(self.characters, 2)
end

function DatabaseObject:addCharacter(character, name, realm)
	realm = realm or GetRealmName()
	if name and character then
		if not self.characters then
			self.characters = {}
		end
		if not self.characters[realm] then
			self.characters[realm] = {}
		end
		
		self.characters[realm][name] = character
		Ui:updateCharacter(character, name, realm)
	end
	return character, name, realm
end

function DatabaseObject:removeCharacter(name, realm)
	realm = realm or GetRealmName()
	if name and realm and self.characters and self.characters[realm] then
		if self.characters[realm][name] then
			self.characters[realm][name] = nil
		end
	end
end

function DatabaseObject:getCharacterCount()
	local count = 0
	for realm, realmDatabase in pairs(self.characters) do
		for name, character in pairs(realmDatabase) do
			count = count + 1
		end
	end
	return count
end

function DatabaseObject:getCharacterLooseMatch(name, realm)
	realm = strtrim(realm or GetRealmName())
	if name and realm and self.characters then
		name = strtrim(strucfirst(string.lower(name)))
		local realmDatabase = self.characters[realm]
		if not realmDatabase then
			for otherRealm, otherRealmDatabase in pairs(self.characters) do
				local comparisonRealm = strlower(strstripNonAlphaNumeric(realm))
				if comparisonRealm == strlower(strstripNonAlphaNumeric(otherRealm)) then
					realmDatabase = otherRealmDatabase
					realm = otherRealm
					break
				end
			end
		end
		if realmDatabase and realmDatabase[name] then
			local character = realmDatabase[name]
			if character then
				return CharacterObject:new(character), name, realm
			end
		end
	end
	return nil, name, realm
end

function DatabaseObject:getCharacter(name, realm)
	realm = realm or GetRealmName()
	if name and realm and self.characters then
		local realmDatabase = self.characters[realm]
		if realmDatabase then
			local character = realmDatabase[name]
			if character then
				return CharacterObject:new(realmDatabase[name]), name, realm
			end
		end
	end
	return nil, name, realm
end

function DatabaseObject:getCharacterFromUnitId(unitId)
	local name, realm = UnitName(unitId)
	return self:getCharacter(name, realm)
end

function DatabaseObject:addCharacterFromUnitId(unitId)
	if UnitIsPlayer(unitId) then
		local character
		if CanInspect(unitId) then
			character = CharacterObject:loadFromUnitId(unitId)
		end
		local name, realm = UnitName(unitId)
		realm = realm or GetRealmName()
		return self:addCharacter(character, name, realm)
	end
end