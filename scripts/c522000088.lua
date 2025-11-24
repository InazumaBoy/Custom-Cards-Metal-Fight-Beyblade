--Spin Track - 105
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x274),LOCATION_MZONE)
	--Gain ATK for each Xyz Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.attackcon)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Negate the attack of a monster with high height
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negatecon)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_series={0x274,0x271,0x270}
function s.attackcon(e)
	return e:GetHandler():IsSetCard(0x270)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*100
end
function s.filter(c)
	return c:IsCode(522000093,522000098,522000107,522000115,522000120)
end
function s.negatecon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return e:GetHandler():IsSetCard(0x270) and a~=e:GetHandler() and a:GetOverlayGroup():IsExists(s.filter,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end