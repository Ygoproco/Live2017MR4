--Ｔｈｅ ｂｌａｚｉｎｇ ＭＡＲＳ
function c100000301.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c100000301.spcon)
	e1:SetOperation(c100000301.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100000301.cost)
	e2:SetTarget(c100000301.target)
	e2:SetOperation(c100000301.operation)
	c:RegisterEffect(e2)
end
function c100000301.chkfilter(c,ft,sg,rg)
	local res
	if sg:GetCount()<3 then
		sg:AddCard(c)
		res=rg:IsExists(c100000301.chkfilter,1,sg,ft,sg,rg)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c100000301.mzfilter,nil)+ft>0
	end
	return res
end
function c100000301.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c100000301.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c)
end
function c100000301.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c100000301.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-3 and rg:GetCount()>2 and rg:IsExists(c100000301.chkfilter,1,nil,ft,Group.CreateGroup(),rg)
end
function c100000301.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c100000301.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	while g:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=rg:Filter(c100000301.chkfilter,g,ft,g,rg):SelectUnselect(g,tp)
		if g:IsContains(tc) then
			g:RemoveCard(tc)
		else
			g:AddCard(tc)
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100000301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,nil)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cc=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,1,nil);
	Duel.SendtoGrave(cc,REASON_COST)
end
function c100000301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100000301.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end