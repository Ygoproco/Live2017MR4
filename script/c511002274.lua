--Judgment of the Underworld Ruler
function c511002274.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c511002274.condition)
	e1:SetTarget(c511002274.target)
	e1:SetOperation(c511002274.activate)
	c:RegisterEffect(e1)
end
function c511002274.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp~=tp
end
function c511002274.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c511002274.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(0x80000000) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511002274.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(68722455)
end
function c511002274.chkfilter(c,ft,sg,rg)
	local res
	if sg:GetCount()<5 then
		sg:AddCard(c)
		res=rg:IsExists(c511002274.chkfilter,1,sg,ft,sg,rg)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c511002274.mzfilter,nil)+ft>0
	end
	return res
end
function c511002274.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c511002274.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetMatchingGroup(c511002274.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local spg=Duel.GetMatchingGroup(c511002274.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft>-5 and rg:GetCount()>4 and rg:IsExists(c511002274.chkfilter,1,nil,ft,Group.CreateGroup(),rg) and spg:GetCount()>0 
		and Duel.SelectYesNo(tp,aux.Stringid(62742651,2)) then
		Duel.BreakEffect()
		local g=Group.CreateGroup()
		while g:GetCount()<5 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=rg:Filter(c511002274.chkfilter,g,ft,g,rg):SelectUnselect(g,tp)
			if g:IsContains(tc) then
				g:RemoveCard(tc)
			else
				g:AddCard(tc)
			end
		end
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=spg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
