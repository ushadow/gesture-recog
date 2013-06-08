% Script to compute head positions in the first frames

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012



droot='/Users/isabelle/Documents/Projects/DARPA/';
datadir=[droot 'DistributedChallengeData'];

% Path where to find data and code

codedir=[droot 'Software/Recognizer/'];
addpath(codedir);

this_dir=pwd;
gdc_dir='/Users/isabelle/Documents/Projects/DARPA/GDC';
cd(gdc_dir);
set_path;
cd(this_dir);

set_names={'valid','devel'};

labels=[];
skeleton_annotation=[];
nn=0;

debug=0;

for i=1:length(set_names)
    set_name=set_names{i};
    if strcmp(set_name, 'devel')
        bmax=480;
    else
        bmax=20;
    end
    for batch_num=1:bmax
        
        if batch_num<=20
            datadir=[droot 'DistributedChallengeData'];
        else
            datadir=[droot 'Lossless_compressed_sata/new_devel_dir'];
        end
        batch_dir=sprintf('%s/%s%02d/', datadir, set_name, batch_num); 

        if debug
            movie_range=1;
        else
            movie_range=1:47;
        end
        
        data_name=sprintf('%s%02d', set_name, batch_num); 
        fprintf('\n%s\n', data_name);
        
        for movie_num=movie_range
            
            fprintf('%d ', movie_num);
            
            M=get_movie([datadir '/' data_name], movie_num);
            
            if ~isempty(M)
                if debug
                    [~, ~, ~, head_box, quality]=annotate(M,1,1,1);
                else
                    [~, ~, ~, head_box, quality]=annotate(M);
                end

                nn=nn+1;
                labels(nn).dataset_name=data_name;
                labels(nn).videos=movie_num;
                labels(nn).frame=1;
                skeleton_annotation(nn,1)=nn;
                skeleton_annotation(nn,2)=3;
                skeleton_annotation(nn,3)=1-quality;
                skeleton_annotation(nn,4:7)=head_box;
            end
        end

    end
end

