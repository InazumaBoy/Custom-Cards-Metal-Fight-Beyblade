--Face Bolt - Wolf
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x272),LOCATION_MZONE)
end

s.listed_series={0x270,0x272,0x271}

function s.attackcon(e)
	return e:GetHandler():IsSetCard(0x270)
end