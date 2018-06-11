% count contact number of each region oi

L_VLa = 0; R_VLa = 0; L_VLp = 0; R_VLp = 0; L_other = 0; R_other = 0;
for contact_idx = 1:length(contact_info)
    if strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLa')
        L_VLa = L_VLa + 1;
    elseif strcmp(contact_info(contact_idx).side,'right') && strcmp(contact_info(contact_idx).group_used,'VLa')
        R_VLa = R_VLa + 1;
    elseif strcmp(contact_info(contact_idx).side,'left') && strcmp(contact_info(contact_idx).group_used,'VLp')
        L_VLp = L_VLp + 1;
    elseif strcmp(contact_info(contact_idx).side,'right') && strcmp(contact_info(contact_idx).group_used,'VLp')
        R_VLp = R_VLp + 1;
    elseif strcmp(contact_info(contact_idx).side,'right')
        R_other = R_other + 1;
    elseif strcmp(contact_info(contact_idx).side,'left')
        L_other = L_other + 1;
    end
end
