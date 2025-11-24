--Wheel - Pegasis
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x273),LOCATION_MZONE)
	--Gain ATK for each Xyz Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.attackcon)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Gain DEF for each Xyz Material
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(s.defval)
	c:RegisterEffect(e2)
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
	--When this card attack, Gain 600 ATK
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_XMATERIAL)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.smashcon)
	e6:SetValue(600)
	c:RegisterEffect(e6)
end
s.listed_series={0x273,0x271,0x270}
function s.attackcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x270)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*500
end
function s.defval(e,c)
	return c:GetOverlayCount()*100
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rec=c:GetOverlayCount()*100
	Duel.Recover(tp,rec,REASON_EFFECT)
end
function s.smashcon(e)
   local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and a and a==e:GetHandler() and e:GetHandler():IsSetCard(0x270) and d and d:IsControler(1-e:GetHandlerPlayer())
end