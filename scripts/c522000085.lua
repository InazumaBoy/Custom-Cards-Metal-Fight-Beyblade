--BeyBlader Gingka Hagane
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	-- 4 or more Monsters Level 1 Bey Parts
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x271),1,4,nil,nil,Xyz.InfiniteMats)
	--Gains 100 ATK/DEF per monster in the GYs
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.value)
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
s.listed_names={522000086}
function s.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,0,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,0x270)*100
end
function s.confilter (c,tp)
	return c:IsCode(522000086) and c:IsSummonPlayer(tp)
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