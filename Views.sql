

-- View for Mayor --

CREATE VIEW MayorResult2017_vw AS (
	SELECT DISTINCT CRV.CandidateNames,
			CRV.OfficeTypes,
			CRV.CandidateTypes,
			WC.OldWardIDs,
			CI.FK1_NewWardIDs,
			RSVSRV.VotingStationIDs,
			RSVSRV.VotingStationNames,
			RSVSRV.VotingStationTypes,
			CI.CommunityNames,
			VC.VoteCounts,
			VI.EnumeratedElectorsNumbers,
			VI.VoterTurnouts
	FROM Candidate_Result_vw AS CRV
	INNER JOIN VoteCount AS VC
		ON CRV.CandidateIDs = VC.FK_CandidateIDs
	INNER JOIN RegularSpecialVotingStation_Result_vw AS RSVSRV
		ON RSVSRV.VotingStationIDs = VC.FK2_VotingStationIDs
	INNER JOIN VoterInformation AS VI
		ON VI.FK1_VotingStationIDs = RSVSRV.VotingStationIDs
	INNER JOIN CommunityInformation AS CI
		ON CI.PK_CommunityIDs = RSVSRV.CommunityIDs
	INNER JOIN WardChange AS WC
		ON WC.FK2_NewWardIDs = CI.FK1_NewWardIDs
	WHERE OfficeTypes = 'Mayor');



-- View for Community Demographics with Number Values --

CREATE VIEW CommunityDemographics2017Number_vw AS (
	SELECT DISTINCT CI.PK_CommunityIDs AS CommunityIDs,
			CI.CommunityNames,
			CI.CommunityPopulations,
			C.CitizenNumbers,
			C.NonCitizenNumbers,
			G.FemaleNumbers,
			G.MaleNumbers,
			AG.Age20_29Numbers,
			AG.Age30_39Numbers,
			AG.Age40_49Numbers,
			AG.Age50_59Numbers,
			AG.Age60_69Numbers,
			AG.Age70_79Numbers,
			AG.AgeMoreThan80Numbers,
			MI.IncomeLessThan59kNumbers,
			MI.Income60K_99999Numbers,
			MI.Income100K_149999Numbers,
			MI.Income150K_199999Numbers,
			MI.IncomeMoreThan200KNumbers,
			F.FamiliesWChildrenNumbers,
			F.FamiliesWOChildrenNUmbers,
			HO.HomeOwnersNumbers,
			HO.RentersNumbers
	FROM CommunityInformation AS CI
	INNER JOIN Citizenship AS C
		ON CI.PK_CommunityIDs = C.FK2_CommunityIDs
	INNER JOIN Gender AS G
		ON CI.PK_CommunityIDs = G.FK6_CommunityIDs
	INNER JOIN AgeGroup AS AG
		ON CI.PK_CommunityIDS = AG.FK4_CommunityIDs
	INNER JOIN MedianIncome AS MI
		ON CI.PK_CommunityIDs = MI.FK1_CommunityIDs
	INNER JOIN Family AS F
		ON CI.PK_CommunityIDs = F.FK3_CommunityIDs
	INNER JOIN HomeOwnership AS HO
		ON CI.PK_CommunityIDs = HO.FK5_CommunityIDs);

