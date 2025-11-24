--BeyBlader Ryuuga
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	-- 4 or more Monsters Level 1 Bey Parts
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x271),1,4,nil,nil,Xyz.InfiniteMats)
	--Recover Life Points
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.reccon)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	 --Special Summon the Materials
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.listed_series={0x271,0x270,0x273,0x274,0x275}
s.listed_names={522000110}
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	local c=Duel.GetAttacker()
	return c==e:GetHandler() and bc
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.confilter (c,tp)
	return c:IsCode(522000110) and c:IsSummonPlayer(tp)
end 
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(s.confilter,1,nil,tp)
end
function s.filter(c,e,tp,code)
	return c:IsSetCard(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local locs=LOCATION_DECK 
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return false end
		e:SetLabel(0)
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
			and Duel.IsExistingMatchingCard(s.filter,tp,locs,0,1,nil,e,tp,0x273)
			and Duel.IsExistingMatchingCard(s.filter,tp,locs,0,1,nil,e,tp,0x274)
			and Duel.IsExistingMatchingCard(s.filter,tp,locs,0,1,nil,e,tp,0x275)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,locs)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local locs=LOCATION_DECK
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,locs,0,nil,e,tp,0x273)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,locs,0,nil,e,tp,0x274)
	local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,locs,0,nil,e,tp,0x275)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg3)
		for tc in aux.Next(sg1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end