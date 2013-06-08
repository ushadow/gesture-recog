function prepare_final_resu(data_dir, resu_file)
% prepare_final_resu(data_dir, resu_file)
%                           CHALEARN GESTURE CHALLENGE
%                   EXAMPLE MATLAB CODE TO PREPARE FINAL RESULTS
%data_dir: the directory where we find the data batches.
%resu_file: the result file in csv format

% IMPORTANT: Make sure that the code is self-contained. Any dependence on
% libraries to be installed requires prior approval of the organizers.
% Otherwise, it is assumed that the code includes all the necessary
% libraries. Instructions must be provided is path variables need to be set
% in a particular way.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012
% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% ISABELLE GUYON AND/OR OTHER CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

%% Initialization
if nargin<2
    resu_file='my_predict.csv';
end
if nargin<1
    data_dir='../Data';
end

% Change this as needed
code_dir=pwd;                       % Where the sample code functions are
resu_dir    = [code_dir '/temp'];   % Where the results will end up 

% Set the path and defaults properly; create directories; enable debug mode
warning off; 
addpath(genpath(code_dir)); 
warning on;
makedir(resu_dir);

% Advanced options
debug=0; % Set to 1 to enable debug mode
recog_options={'test_on_training_data=1', 'movie_type=''K'''};

if debug
    dbstop if error
    recog_options =[recog_options 'verbosity=1'];
end

%% List the batches
direc = dir(data_dir); dirnames = {};
[dirnames{1:length(direc),1}] = deal(direc.name);
% remove the . files
direc = dir([data_dir '/.*']); baddir = {};
[baddir{1:length(direc),1}] = deal(direc.name);
dirnames=setdiff(dirnames, baddir);

%% Train/Test
% LOOP OVER BATCHES 
% =================

for k=1:length(dirnames)
    
    set_name=dirnames{k};
    fprintf('%s ... ', set_name);
        
    %try

        % Load training and test data
        dt=sprintf('%s/%s', data_dir, set_name);
        if ~exist(dt),fprintf('No data for %s\n', set_name); continue; end
        D=databatch(dt);

        % Split the data into training and test set
        Dtr=subset(D, 1:D.vocabulary_size);
        Dte=subset(D, D.vocabulary_size+1:length(D));

        % Train a trivial model
        [tr_resu, mymodel]=train(basic_recog(recog_options), Dtr);

        % Test the model
        te_resu=test(mymodel, Dte);

        % Save the results for validation and final data 
        save(te_resu, [resu_dir '/' set_name '_predict.csv'], [set_name '_'], 'w');
        
        fprintf('done\n');
    %catch
        %fprintf('failed\n');
    %end
    
end

% Prepare the submission by concatenating the results
prepare4submit('my', resu_dir);
movefile([resu_dir '/my_predict.csv'], resu_file);

end
