--Coingnoma the Sibyl
function c511000589.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000589,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c511000589.target)
	e1:SetOperation(c511000589.operation)
	c:RegisterEffect(e1)
end
function c511000589.filter(c)
	return c:IsLevelBelow(4) and c:IsType(TYPE_FLIP) and (not c:IsCode(32231618) or not c:IsLocation(LOCATION_GRAVE)) 
		and c:IsSummonableCard() and not c:IsStatus(STATUS_FORBIDDEN) and not c:IsHasEffect(EFFECT_CANNOT_MSET)
end
function c511000589.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000589.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c511000589.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c511000589.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
		tc:SetStatus(STATUS_SUMMON_TURN,true)
		Duel.RaiseEvent(tc,EVENT_MSET,e,REASON_EFFECT,tp,tp,0)
	end
end
