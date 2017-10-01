--デザート・ツイスター
function c81977953.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81977953.spcon)
	e2:SetOperation(c81977953.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81977953,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c81977953.descost)
	e3:SetTarget(c81977953.destg)
	e3:SetOperation(c81977953.desop)
	c:RegisterEffect(e3)
end
function c25460258.chkfilter(c,ft,sg,rg)
	local res
	if sg:GetCount()<3 then
		sg:AddCard(c)
		res=rg:IsExists(c25460258.chkfilter,1,sg,ft,sg,rg)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c25460258.mzfilter,nil)+ft>0 and sg:IsExists(c25460258.atchk1,1,nil,sg)
	end
	return res
end
function c25460258.atchk1(c,sg)
	return c:IsAttribute(ATTRIBUTE_EARTH) and sg:FilterCount(Card.IsAttribute,c,ATTRIBUTE_WIND)==2
end
function c81977953.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c81977953.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(c25460258.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH)
	local rg2=Duel.GetMatchingGroup(c25460258.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-3 and rg1:GetCount()>0 and rg2:GetCount()>1 and rg:IsExists(c25460258.chkfilter,1,nil,ft,Group.CreateGroup(),rg)
end
function c81977953.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c25460258.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND)
	local g=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	while g:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=rg:Filter(c25460258.chkfilter,g,ft,g,rg):SelectUnselect(g,tp)
		if g:IsContains(tc) then
			g:RemoveCard(tc)
		else
			g:AddCard(tc)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81977953.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c81977953.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81977953.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c81977953.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81977953.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81977953.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81977953.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
