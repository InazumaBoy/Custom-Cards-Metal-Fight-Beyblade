--Performance Tip- Ball
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x275),LOCATION_MZONE)
	--Gain DEF for each Xyz Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.attackcon)
	e1:SetValue(s.defval)
	c:RegisterEffect(e1)
	--Gain ATK for each Xyz Material
	--local e2=e1:Clone()
	--e2:SetCode(EFFECT_UPDATE_ATTACK)
   -- e2:SetValue(s.atkval)
   -- c:RegisterEffect(e2)
	-- Gain Life Points for each Xyz Material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.attackcon)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	-- Force to be in the Center
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(s.attackcon)
	e6:SetOperation(s.seqop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
s.listed_series={0x275,0x271,0x270}
function s.attackcon(e)
	return e:GetHandler():IsSetCard(0x270)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end
function s.defval(e,c)
	return c:GetOverlayCount()*400
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rec=c:GetOverlayCount()*300
	Duel.Recover(tp,rec,REASON_EFFECT)
end
function s.summoncon (e)
	return e:GetHandler():IsSetCard(0x270) and e:GetHandler():GetSequence()~=2
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_MZONE,2) then return end
	Duel.MoveSequence(c,2)
end