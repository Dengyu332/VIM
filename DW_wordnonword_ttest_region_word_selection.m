% First created on 10/18/2018

% Do statistical test using UnitWordNonword_Response tables

% Here we focus on higamma period 2 (0.5 post sp)

DW_machine;

load([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/WordVsNonword/speech_response_table.mat']);

% find group you want, either left s1, left s2 or right
a =  [];
for i = 40:height(word_nonword_response_table)
    if word_nonword_response_table.ith_session{i} == 1   & strcmp(word_nonword_response_table.side{i}, 'right')
        a = [a,i];
    end
end

% SigUp unit, based on -0.5 - 0.5 perisp, 120 trials, FDR corrected
candid = find(speech_response_table.ref_highgamma_period2_120_p * 123 < 0.05 & speech_response_table.ref_highgamma_period2_120_h == 1);

a = intersect(a,candid);

temp = word_nonword_response_table(a,:);

[h,p,~,stat] = ttest(temp.word,temp.nonword)