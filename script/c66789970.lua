--聖刻龍－セテクドラゴン
function c66789970.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c66789970.hspcon)
	e1:SetOperation(c66789970.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66789970,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c66789970.descost)
	e2:SetTarget(c66789970.destg)
	e2:SetOperation(c66789970.desop)
	c:RegisterEffect(e2)
end
function c66789970.chkfilter(c,ft,sg,rg)
	local res
	if sg:GetCount()<3 then
		sg:AddCard(c)
		res=rg:IsExists(c66789970.chkfilter,1,sg,ft,sg,rg)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c66789970.mzfilter,nil)+ft>0
	end
	return res
end
function c66789970.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c66789970.rfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c66789970.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c66789970.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-3 and rg:GetCount()>2 and rg:IsExists(c66789970.chkfilter,1,nil,ft,Group.CreateGroup(),rg)
end
function c66789970.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c66789970.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	while g:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=rg:Filter(c66789970.chkfilter,g,ft,g,rg):SelectUnselect(g,tp)
		if g:IsContains(tc) then
			g:RemoveCard(tc)
		else
			g:AddCard(tc)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66789970.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c66789970.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66789970.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66789970.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66789970.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66789970.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
