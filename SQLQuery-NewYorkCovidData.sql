---I got the New York City Covid dataset from kaggle. It contains the total cases, total hospitalized and total deaths of 5 cities in New York. 
---I have queried the data to compare the numbers against themselves. 
---For example, in the 5th query, I attempted to find out the percentage of people from the total cases were hospitalised?
---Thank you.



Select *
From NYCovidData

--Select the relevant data

Select Date_of_interest, Case_Count, Hospitalized_Count, Death_Count,
        BX_Case_Count, BX_Hospitalized_Count, BX_Death_Count,
        BK_Case_Count, BK_Hospitalized_Count, BK_Death_Count, 
        MN_Case_Count, MN_Hospitalized_Count, MN_Death_Count,
        QN_Case_Count, QN_Hospitalized_Count, QN_Death_Count,
        SI_Case_Count, SI_Hospitalized_Count, SI_Death_Count

From NYCovidData
order by 3 DESC

--Showing the maximum number in all cities in the state

Select Max(Case_Count) MaxCount, Max(BX_Case_Count) BXCount, Max(BK_Case_Count) BKCount, Max(MN_Case_Count) MNCount, Max(QN_Case_Count) QNCount, Max(SI_Case_Count) SICount
From NYCovidData

--Using order by


Select Date_of_interest, Case_Count, Hospitalized_Count, Death_Count,
        BX_Case_Count, BX_Hospitalized_Count, BX_Death_Count,
        BK_Case_Count, BK_Hospitalized_Count, BX_Death_Count, 
        MN_Case_Count, MN_Hospitalized_Count, MN_Death_Count,
        QN_Case_Count, QN_Hospitalized_Count, QN_Death_Count,
        SI_Case_Count, SI_Hospitalized_Count, SI_Death_Count

From NYCovidData
order by 2 DESC

--What percentage of the total case count is the hospitalised count? How many people from the total cases were hospitalised?

Select Case_Count, Hospitalized_Count, (Case_Count*1.0/Hospitalized_Count) *100 PercentHospitalized
From NYCovidData
where Case_Count <>0
and Hospitalized_Count<>0
order by 1 Desc

--What Percentage of the total cases died per day?

Select Date_of_interest, Case_Count, Death_Count, (Death_Count*1.0/Case_Count) *100 PercentDead
From NYCovidData
where Case_Count <>0
and Death_Count<>0
order by 2 Desc


--What percent of total cases in NY were from individual cities on every given day?


Select Date_of_interest,
    Case_Count, 
        (BX_Case_Count*1.0/Case_Count) *100 BXCaseCount, 
        (BK_Case_Count*1.0/Case_Count) *100 BKCaseCount, 
        (MN_Case_Count*1.0/Case_Count) *100 MNCaseCount,
        (QN_Case_Count*1.0/Case_Count) *100 QNCaseCount, 
        (SI_Case_Count*1.0/Case_Count) *100 SICaseCount
From NYCovidData
where Case_Count <>0
and BX_Case_Count<>0
and BK_Case_Count<>0
and MN_Case_Count<>0
and QN_Case_Count<>0
and SI_Case_Count<>0
order by 2 Desc

-- What percent of total deaths in NY were from individual cities on every given day?

Select Date_of_interest,
    Death_Count, 
        (BX_Death_Count*1.0/Death_Count) *100 BXDeathCount, 
        (BK_Death_Count*1.0/Death_Count) *100 BKDeathCount, 
        (MN_Death_Count*1.0/Death_Count) *100 MNDeathCount,
        (QN_Death_Count*1.0/Death_Count) *100 QNDeathCount, 
        (SI_Death_Count*1.0/Death_Count) *100 SIDeathCount
From NYCovidData
where Death_Count <>0
and BX_Death_Count<>0
and BK_Death_Count<>0
and MN_Death_Count<>0
and SI_Death_Count<>0
order by 2 Desc


--What percent of people hospitalized in NY were from individual cities on every given day?

Select Date_of_interest,
    Hospitalized_Count, 
        (BX_Hospitalized_Count*1.0/Hospitalized_Count) *100 BXHospitalizedCount, 
        (BK_Hospitalized_Count*1.0/Hospitalized_Count) *100 BKHospitalizedCount, 
        (MN_Hospitalized_Count*1.0/Hospitalized_Count) *100 MNHospitalizedCount,
        (QN_Hospitalized_Count*1.0/Hospitalized_Count) *100 QNHospitalizedCount, 
        (SI_Hospitalized_Count*1.0/Hospitalized_Count) *100 SIHospitalizedCount
From NYCovidData
where Hospitalized_Count <>0
and BX_Hospitalized_Count<>0
and BK_Hospitalized_Count<>0
and MN_Hospitalized_Count<>0
and QN_Hospitalized_Count<>0
and SI_Hospitalized_Count<>0
order by 2 Desc




