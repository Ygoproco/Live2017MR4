--Garbage Collection
function c511001066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511001066.cost)
	e1:SetTarget(c511001066.target)
	e1:SetOperation(c511001066.activate)
	c:RegisterEffect(e1)
end
function c511001066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511001066.cfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_MACHINE) and aux.SpElimFilter(c,true)
end
function c511001066.chkfilter(c,ft,sg,rg,e,tp)
	local res
	if sg:GetCount()<2 then
		sg:AddCard(c)
		res=rg:IsExists(c511001066.chkfilter,1,sg,ft,sg,rg,e,tp)
		sg:RemoveCard(c)
	else
		res=sg:FilterCount(c511001066.mzfilter,nil)+ft>0 and Duel.IsExistingTarget(c511000310.spfilter,tp,LOCATION_GRAVE,0,1,sg,e,tp)
	end
	return res
end
function c511001066.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c511001066.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511001066.spfilter(chkc,e,tp) end
	local chkcost=e:GetLabel()==1 and true or false
	local rg=Duel.GetMatchingGroup(c511001066.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if chkcost then
			e:SetLabel(0)
			return ft>-2 and rg:GetCount()>1 and rg:IsExists(c511001066.chkfilter,1,nil,ft,Group.CreateGroup(),rg,e,tp)
		else
			return ft>0 and Duel.IsExistingTarget(c511000310.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	if chkcost then
		local g=Group.CreateGroup()
		while g:GetCount()<2 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=rg:Filter(c511001066.chkfilter,g,ft,g,rg,e,tp):SelectUnselect(g,tp)
			if g:IsContains(tc) then
				g:RemoveCard(tc)
			else
				g:AddCard(tc)
			end
		end
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511001066.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511001066.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
