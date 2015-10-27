% function linked2neurites_error (input_groupname)
% global pooled
%pool neurites
% experiment 11.12_rr_101

%load graphdb
% [db,filename] = load_graphdb;

%load groupdb
groupdb=load_groupdb;
[testdb.db, testdb.filename] = load_testdb('tp');
% define groups
strgroups = {'11.12 no lesion'};
%or manually enter strgroups ={'11.12 lesion','11.12 lesion'};
%%
n_groups = length(strgroups);
groups = cell(n_groups,1);
for g=1:n_groups
    ind_g = structfind(groupdb,'name',strgroups{g});
    groups(g)= {groupdb(ind_g).filter};
end
%%
linked2neurite_array = struct([]);
for g=1:n_groups
    strmice = strsplit(groups{g}, '|');
    strmice = strrep(strmice, 'mouse=', '');
    %     new_database_array(g).linked2neurite = [];
    %     Cnt = 1;
    for i_mouse=1:length(strmice)
        disp(['Mouse: ' strmice{i_mouse}])
        mouse_specific_entries = structfind(testdb.db,'mouse',strmice{i_mouse});
        mouserec = struct([]);
        for i_record = mouse_specific_entries;
            mouserec = [mouserec testdb.db(mouse_specific_entries(i_record))];
        end
        for i_record = mouse_specific_entries;
            stack_name = mouserec(i_record).stack;
            stack_specific_entries = structfind(mouserec,'stack',stack_name);
            stackrec = struct([]);
            for i_stack = stack_specific_entries
                stackrec = [stackrec mouserec(i_stack)];
                data=stackrec.measures;
                for i_data=1:length(data)
                    measures = data(i_data);
                    err = 0;
                    try
                        evaluated_criteria = eval ('measures.bouton == 1');
                    catch errmsg
                        err = 1;
                        disp('Failed to evaluate criteria')
                    end
                    bouton_rois = struct([]);
                    if ~isempty(evaluated_criteria) && ~err && evaluated_criteria
                        bouton_rois=[bouton_rois measures.index];
                    end
                end
            end
        end
    end
end
        
                
                
                
                
%                 if ~isempty(evaluated_criteria) && ~err && evaluated_criteria
%                     x = stackrec.mouse;
%                     y = stackrec.stack;
%                     linked2neurite_array(g).x.y{Cnt,1} = stackrec.mouse;
%                     linked2neurite_array(g).x.y{Cnt,2} = stackrec.stack;
%                     linked2neurite_array(g).x.y{Cnt,3} = stackrec.index;
%                     
%                     
%                 end
%             end
%             Cnt = Cnt + 1;
%             linked2neurite_array(g).index{Cnt,1} = mouserec.mouse;
%             linked2neurite_array(g).index{Cnt,2} = mouserec.stack;
%             linked2neurite_array(g).index{Cnt,3} = mouserec.index;
%             linked2neurite_array(g).index{Cnt,4} = measures.linked2neurite;
            
            %             new_database_array(g).linked2neurite{Cnt,2} = linked2neurite;
            %             new_database_array(g).linked2neurite{Cnt,3} = dbrec.mouse;
            %             new_database_array(g).linked2neurite{Cnt,4} = dbrec.stack;
            %             new_database_array(g).linked2neurite{Cnt,5} = dbrec.slice;
            %             disp(['Cnt = ', num2str(Cnt)])
%         end %records for each mouse
%     end % mouse
% end %group
% % 

%  Poolfor = '(measures.bouton==1 | measures.mito==1)'; 
% % time = '0';
% % pool_short_neurites = 5;
% % timepoints = [];
% 
%timepoint = ['day' time];
%             if isfield(dbrec, 'slice')
%                 timepoint = dbrec.slice;
%             end
%             
            %get all rois in measurement table according to measure criteria
% 
% %%
