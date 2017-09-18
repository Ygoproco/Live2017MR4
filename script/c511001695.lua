--Cardian - Matsu
function c511001695.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001695,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511001695.spcost)
	e1:SetTarget(c511001695.sptg)
	e1:SetOperation(c511001695.spop)
	c:RegisterEffect(e1,false,2)
end
function c511001695.filter(c,tp)
	local re=c:GetReasonEffect()
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:GetSequence()<5) and c:GetLevel()==1 and c:IsSetCard(0xe6)
		and (not c:IsSummonType(SUMMON_TYPE_SPECIAL) or (not re or not re:GetHandler():IsSetCard(0xe6) or not re:GetHandler():IsType(TYPE_MONSTER)))
end
function c511001695.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511001695.filter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c511001695.filter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c511001695.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511001695.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			local ok=false
			if tc:IsSetCard(0xe6) and tc:IsType(TYPE_MONSTER) then
				local eff={tc:GetCardEffect(511001692)}
				for _,te2 in ipairs(eff) do
					local te=te2:GetLabelObject()
					local con=te:GetCondition()
					local cost=te:GetCost()
					local tg=te:GetTarget()
					if te:GetType()==EFFECT_TYPE_FIELD then
						if not con or con(te,tc) then
							ok=true
						end
					elseif te:GetType()==EFFECT_TYPE_IGNITION then
						if (not con or con(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0) 
							and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)))
					end
					if ok then break end
				end
			end
			if ok then
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
