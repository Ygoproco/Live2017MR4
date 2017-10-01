--Sealed Gate
function c511000597.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(511000597,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c511000597.spcon)
	e1:SetCost(c511000597.spcost)
	e1:SetTarget(c511000597.sptg)
	e1:SetOperation(c511000597.spop)
	c:RegisterEffect(e1)
end
function c511000597.chkfilter(c,ft,sg,rg)
	local res
	if sg:GetCount()<3 then
		sg:AddCard(c)
		res=rg:IsExists(c511000597.chkfilter,1,sg,ft,sg,rg)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c511000597.mzfilter,nil)+ft>0 and sg:IsExists(c511000597.chk,1,nil,Group.CreateGroup(),sg,511000596,511000594,511000593)
	end
	return res
end
function c511000597.chk(c,g,sg,code,...)
	if not c:IsCode(code) then return false end
	local res=true
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c511000597.chk,1,g,g,sg,...)
		g:RemoveCard(c)
	end
	return res
end
function c511000597.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c511000597.cfilter(c,...)
	return c:IsCode(...) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c511000597.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg1=Duel.GetMatchingGroup(c511000597.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,511000596)
	local rg2=Duel.GetMatchingGroup(c511000597.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,511000594)
	local rg3=Duel.GetMatchingGroup(c511000597.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,511000593)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-3 and rg1:GetCount()>0 and rg2:GetCount()>0 and rg3:GetCount()>0 
		and rg:IsExists(c511000597.chkfilter,1,nil,ft,Group.CreateGroup(),rg)
	local g=Group.CreateGroup()
	while g:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=rg:Filter(c511000597.chkfilter,g,ft,g,rg):SelectUnselect(g,tp)
		if g:IsContains(tc) then
			g:RemoveCard(tc)
		else
			g:AddCard(tc)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511000597.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c511000597.filter(c,e,tp)
	return c:IsCode(511000595) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511000597.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000597.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c511000597.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000597.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end
