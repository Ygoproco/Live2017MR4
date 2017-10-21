--ボンディング－H2O
function c45898858.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c45898858.cost)
	e1:SetTarget(c45898858.target)
	e1:SetOperation(c45898858.activate)
	c:RegisterEffect(e1)
end
function c45898858.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c45898858.chk,1,nil,sg)
end
function c45898858.chk(c,sg)
	return c:IsCode(58071123) and sg:IsExists(Card.IsCode,2,c,22587018)
end
function c45898858.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp)
	local g1=rg:Filter(Card.IsCode,nil,22587018)
	local g2=rg:Filter(Card.IsCode,nil,58071123)
	local g=g1:Clone()
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and g1:GetCount()>1 and g2:GetCount()>0 and g:GetCount()>2 
		and aux.SelectUnselectGroup(g,e,tp,3,3,c45898858.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,c45898858.rescon,1,tp,HINTMSG_RELEASE)
	Duel.Release(sg,REASON_COST)
end
function c45898858.filter(c,e,tp)
	return c:IsCode(85066822) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c45898858.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c45898858.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c45898858.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45898858.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
