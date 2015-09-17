
global pooled 
% pool neurites
% experiment 11.12_ls_axons

%load graphdb
[db,filename] = load_graphdb;

%load groupdb
groupdb=load_groupdb;

[testdb.db, testdb.filename] = load_testdb('tp');

strgroups = {'11.12 no lesion', '11.12 lesion'}; 
% RR: change experiment groups here as per group_db
n_groups = length(strgroups);
groups = cell(n_groups,1);
    for g=1:n_groups
        ind_g = structfind(groupdb,'name',strgroups{g});
        groups(g)= {groupdb(ind_g).filter};
    end

Poolfor = '(measures.mito==1)'; % RR: change for mito or bouton
time = '0';
%pool_short_neurites = 5;



%%

allgroups = struct([]);
for g=1:n_groups
    strmice = strsplit(groups{g}, '|');
    strmice = strrep(strmice, 'mouse=', '');
    allgroups(g).groups = strmice;
    allgroups(g).recordlist = [];

    Roicnt = 0; 
    poolindex = 0;
    for i_mouse=1:length(strmice)
        disp(['Mouse: ' strmice{i_mouse}])
        indtests = structfind(testdb.db,'mouse',strmice{i_mouse});
        
        stackid = {};
        for i_record = indtests           
            dbrec = testdb.db(i_record);
            cellist = dbrec.ROIs.celllist;
            strday = dbrec.slice;
            stack = dbrec.stack;
            
            %get all rois in measurement table according to measure criteria
            Rois = dbrec.measures;
            for i_measure=1:length(Rois)
                measures = Rois(i_measure);
                err = 0;
                try
                    evaluated_criteria = eval(Poolfor);
                    %evaluated_criteria = strcmp(cellist(i_measure).type, 'mito');
                catch errmsg
                    err = 1;
                    disp('Failed to evaluate criteria')
                end
                if ~err && evaluated_criteria %bouton or t_bouton
                    Roicnt = Roicnt + 1;
                     allgroups(g).recordlist{Roicnt, 1} = strmice{i_mouse};
                     allgroups(g).recordlist{Roicnt, 2} = stack;
                     allgroups(g).recordlist{Roicnt, 3} = strday;
                     allgroups(g).recordlist{Roicnt, 4} = measures.index;
%                      allgroups(g).recordlist{Roicnt, 5} = measures.linked2neurite;
                     allgroups(g).recordlist{Roicnt, 6} = measures.present;
%                     allgroups(g).recordlist{Roicnt, 7} = measures.gained;
%                     allgroups(g).recordlist{Roicnt, 8} = measures.lost;
                     allgroups(g).recordlist{Roicnt, 9} = measures.intensity_mean_ch1;
                end
            end
            
        end %records for each mouse
    end % mouse
end %group
