--Face Bolt - Pegasis I
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 Face Bolt on the field
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x272),LOCATION_MZONE)
	--Once per turn, pay 200 life points to attack 1 monster on the field and change battle position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetCondition(s.attackcon)
	e1:SetCost(Cost.PayLP(200))
	e1:SetTarget(s.attacktg)
	e1:SetOperation(s.attackop)
	c:RegisterEffect(e1)
	--Once per turn, if is in the Leftmost or rightmost column, destroy all monsters with low atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.destroycon)
	e2:SetTarget(s.destroytg)
	e2:SetOperation(s.destroyop)
	c:RegisterEffect(e2)
end
s.listed_series={0x270,0x272,0x271}

function s.attackcon(e)
	return e:GetHandler():IsSetCard(0x270)
end
function s.attacktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsAttackable,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.attackop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e)
		and c:CanAttack() and not c:IsImmuneToEffect(e) then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function s.destroycon(e)
	return (e:GetHandler():GetSequence()==0) or (e:GetHandler():GetSequence()==4) and e:GetHandler():IsSetCard(0x270)
end
function s.destroytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsDefenseBelow,e:GetHandler():GetAttack()),tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
end
function s.destroyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsDefenseBelow,c:GetAttack()),tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local ct=#g*100
		Duel.BreakEffect()
		Duel.Damage(tp,ct,REASON_EFFECT)
	end
end