--Face Bolt - L-Drago I
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x272),LOCATION_MZONE)
	 --Once per turn, pay Half of life points to destroy all monsters on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.attackcon)
	e1:SetCost(s.destroycos)
	e1:SetTarget(s.destroytg)
	e1:SetOperation(s.destroyop)
	c:RegisterEffect(e1)
end
s.listed_series={0x270,0x272,0x271}

function s.attackcon(e)
	return e:GetHandler():IsSetCard(0x270)
end
function s.destroycos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.destroytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.destroyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local val=0
	local tg=g:GetFirst()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		while tg do
			val=val+tg:GetPreviousAttackOnField()
			tg=g:GetNext()
		end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end
end