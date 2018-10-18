% takes in SumTimingTable
% count cuelocking and speechlocking number for the band

% test cuelocking vs. speechlocking

find(SumTimingTable.ActOn2PCorrP < 0.05 & abs(SumTimingTable.ActOn2PCorrRho) > abs(SumTimingTable.ActOnCorrRho))

find(SumTimingTable.ActOn2PCorrP < 0.05 & SumTimingTable.ActOnCorrP > 0.05)

find(SumTimingTable.ActOnCorrP < 0.05 & abs(SumTimingTable.ActOn2PCorrRho) < abs(SumTimingTable.ActOnCorrRho))

find(SumTimingTable7.ActOnCorrP < 0.05)


[SumTimingTable.ActOnCorrP, SumTimingTable7.ActOnCorrP]

