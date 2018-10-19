% First created on 10/10/2018
% aims to remove session-combined rows of table_oi

unique_contact = unique(z_table_new.contact_id);
 
for i = 1:length(unique_contact)
    contact_i = unique_contact(i);
    temp = find(z_table_new.contact_id == contact_i);
    if length(temp) == 1
    keep_idx(i) =  temp;
    else
    keep_idx(i) =  temp(3);
    end
end

z_table_new_comparable = z_table_new(keep_idx,:);


unique_contact = unique(speech_response_table_new.contact_id);
hasi = 0;
discard_idx = [];
for i = 1:length(unique_contact)
    
    
    contact_i = unique_contact(i);
    temp = find(speech_response_table_new.contact_id == contact_i);
    if length(temp) == 1
    else
        hasi = hasi + 1;
    discard_idx(hasi) =  temp(3);
    end
end
 speech_response_table_new_comparable = speech_response_table_new;
 speech_response_table_new_comparable(discard_idx,:) = [];