% first created on 08/19
% follows
% DW_anatomical_dependence_of_band_activity_continuous_group_comparison_controlled
% & DW_anatomical_dependence_of_band_activity_continuous_group_comparison

% takes in continuous_group_comparison.mat and
% controlled_continuous_group_comparison.mat

% this script is to combine the result of corr, stepwise regression and
% glme regression, and determine whether a compartment is significant, by
% different criteria

% The principle finding is: ref_highgamma actitivy is correlated with
% pca2 (which is roughly anterior-posterior oriented)

% generate summarize_continuous.mat under
% Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/

% specify machine
DW_machine;

% load in continuous_group_comparison.mat
load([dionysis...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/continuous_group_comparison.mat']);

% load in controlled_continuous_group_comparison.mat
load([dionysis...
    'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/controlled_continuous_group_comparison.mat']);

% start the loop
for combination_idx = 1:length(big_stat)
    
    count_stat(combination_idx).band = control_stat(combination_idx).band;
    count_stat(combination_idx).group = control_stat(combination_idx).group;
    %% X
    % simple corr
    count_stat(combination_idx).X(:,1) = big_stat(combination_idx).AxisCorr(:,1);
    
    % second column is stepwise regression
    if any(strcmp('X',big_stat(combination_idx).stepwise_axis.CoefficientNames))
        count_stat(combination_idx).X(1,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'X','Estimate'};
        count_stat(combination_idx).X(2,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'X','pValue'};
    else
        count_stat(combination_idx).X(:,2) = [NaN;NaN];
    end
    
    % third column is glme
    temp = find(strcmp('X', control_stat(combination_idx).X.Coefficients.Name));
    
    count_stat(combination_idx).X(1,3) = control_stat(combination_idx).X.Coefficients.Estimate(temp);
    count_stat(combination_idx).X(2,3) = control_stat(combination_idx).X.Coefficients.pValue(temp);
    
    %% Y
    % simple corr
    count_stat(combination_idx).Y(:,1) = big_stat(combination_idx).AxisCorr(:,2);
    
    % second column: stepwise regression
    if any(strcmp('Y', big_stat(combination_idx).stepwise_axis.CoefficientNames))
        count_stat(combination_idx).Y(1,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'Y','Estimate'};
        count_stat(combination_idx).Y(2,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'Y','pValue'};
    else
        count_stat(combination_idx).Y(:,2) = [NaN;NaN];
    end
    
    % third column: glme
    temp = find(strcmp('Y', control_stat(combination_idx).Y.Coefficients.Name));
    
    count_stat(combination_idx).Y(1,3) = control_stat(combination_idx).Y.Coefficients.Estimate(temp);
    count_stat(combination_idx).Y(2,3) = control_stat(combination_idx).Y.Coefficients.pValue(temp);
    
    %% Z
    % first col: simple corr
    count_stat(combination_idx).Z(:,1) = big_stat(combination_idx).AxisCorr(:,3);
    
    % second col: stepwise regression
    if any(strcmp('Z',big_stat(combination_idx).stepwise_axis.CoefficientNames))
        count_stat(combination_idx).Z(1,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'Z','Estimate'};
        count_stat(combination_idx).Z(2,2) = big_stat(combination_idx).stepwise_axis.Coefficients{'Z','pValue'};
    else
        count_stat(combination_idx).Z(:,2) = [NaN;NaN];
    end
    
    % third col: glme
    temp = find(strcmp('Z', control_stat(combination_idx).Z.Coefficients.Name));
    
    count_stat(combination_idx).Z(1,3) = control_stat(combination_idx).Z.Coefficients.Estimate(temp);
    count_stat(combination_idx).Z(2,3) = control_stat(combination_idx).Z.Coefficients.pValue(temp);
    
    %% x1
    % first col: simple corr
    count_stat(combination_idx).x1(:,1) = big_stat(combination_idx).PCA.corr(:,1);
    
    % second col: stepwise regression
    if any(strcmp('x1',big_stat(combination_idx).stepwise_PCA.CoefficientNames))
        count_stat(combination_idx).x1(1,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x1','Estimate'};
        count_stat(combination_idx).x1(2,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x1','pValue'};
    else
        count_stat(combination_idx).x1(:,2) = [NaN;NaN];
    end
    
    % third col: glme
    temp = find(strcmp('x1', control_stat(combination_idx).x1.Coefficients.Name));
    
    count_stat(combination_idx).x1(1,3) = control_stat(combination_idx).x1.Coefficients.Estimate(temp);
    count_stat(combination_idx).x1(2,3) = control_stat(combination_idx).x1.Coefficients.pValue(temp);    
    
    %% x2
    % first col: simple corr
    count_stat(combination_idx).x2(:,1) = big_stat(combination_idx).PCA.corr(:,2);
    
    % second col: stepwise regression
    if any(strcmp('x2',big_stat(combination_idx).stepwise_PCA.CoefficientNames))
        count_stat(combination_idx).x2(1,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x2','Estimate'};
        count_stat(combination_idx).x2(2,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x2','pValue'};
    else
        count_stat(combination_idx).x2(:,2) = [NaN;NaN];
    end
    
    % third col: glme
    temp = find(strcmp('x2', control_stat(combination_idx).x2.Coefficients.Name));
    
    count_stat(combination_idx).x2(1,3) = control_stat(combination_idx).x2.Coefficients.Estimate(temp);
    count_stat(combination_idx).x2(2,3) = control_stat(combination_idx).x2.Coefficients.pValue(temp);
    
    %% x3
    % first col: simple corr
    count_stat(combination_idx).x3(:,1) = big_stat(combination_idx).PCA.corr(:,3);
    
    % second col: stepwise regression
    if any(strcmp('x3',big_stat(combination_idx).stepwise_PCA.CoefficientNames))
        count_stat(combination_idx).x3(1,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x3','Estimate'};
        count_stat(combination_idx).x3(2,2) = big_stat(combination_idx).stepwise_PCA.Coefficients{'x3','pValue'};
    else
        count_stat(combination_idx).x3(:,2) = [NaN;NaN];
    end
    
    % third col: glme
    temp = find(strcmp('x3', control_stat(combination_idx).x3.Coefficients.Name));
    
    count_stat(combination_idx).x3(1,3) = control_stat(combination_idx).x3.Coefficients.Estimate(temp);
    count_stat(combination_idx).x3(2,3) = control_stat(combination_idx).x3.Coefficients.pValue(temp);
    
end

readme1 = 'Corr, stepwise and glme; first row is rho, estimate, estimate; second row is p values';

%% for each unit, determine if it's significant (1 or 0); criteria divides to 3 levels (lv1, lv2, lv3)

cp_tbl = count_stat;

cp_tbl = struct2table(cp_tbl);

lv1 = cp_tbl;
lv2 = cp_tbl;
lv3 = cp_tbl;

component_selection = {'X','Y','Z','x1','x2','x3'};

% 1 is significant, 0 is not
for combination_idx = 1:length(count_stat)
    for component_name = component_selection
        
        Ps_oi = cp_tbl{combination_idx,component_name}{:}(2,:);
        
        if Ps_oi(1) <0.05
            lv1{combination_idx,component_name} = {1};
        else
            lv1{combination_idx,component_name} = {0};
        end
        
        if Ps_oi(1) <0.05 && ~isnan(Ps_oi(2))
            lv2{combination_idx,component_name} = {1};
        else
            lv2{combination_idx,component_name} = {0};
        end
        
        if Ps_oi(1) <0.05 && ~isnan(Ps_oi(2)) && Ps_oi(3) <0.05
            lv3{combination_idx,component_name} = {1};
        else
            lv3{combination_idx,component_name} = {0};
        end
    end
end

readme2 = 'lv1: simple corr thresholding; lv2: simple corr + stepwise; lv3: simple corr + stepwise + glme';

save([dionysis 'Users/dwang/VIM/datafiles/preprocessed_new/v2/Anatomical_dependence_of_band_activity/summarize_continuous'],...
    'count_stat','lv1','lv2','lv3','readme1','readme2');