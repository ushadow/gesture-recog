function [resu, this]=train(this, datag)
% PCA training method. The underlying idea is to perform
% PCA on the frames in each video from the vocabulary, storing the PCA
% models. Frames in test-videos are projected into the PCA space and
% reconstructed using each of the PCA models, one for each gesture in the
% vocabulary. Next we measure the reconstruction error for each of the
% models and assign a test video the gesture that obtains the lowest
% reconstruction error. 
% Inputs:
% this       -- A pca_recog object.
% datag      -- A result object (preprocessed data).
%
% Returns:
% this      -- The trained model.
% resu      -- A new data structure containing the results.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2011
% Hugo Jair Escalante -- hugojair@inaoep.mx -- April, 2012

if this.verbosity>0, fprintf('\n==TR> Training %s for movie type %s... ', class(this), this.movie_type); end

Ntr=length(datag);
L=zeros(Ntr, 1);
T=cell(Ntr, 1);

% Preprocessing
for k=1:Ntr
    % Check whether the data is already in a feature representation
    if isa(datag, 'result')
        T{k}=get_X(datag, k);
    else
        goto(datag, k);
        % Compute for each frame a representation based on image differences at
        % a very coarse resolution, called motion histograms
        if strcmp(this.movie_type, 'K')
            % Use the depth image only        
            T{k}=this.preprocessing(datag.current_movie.K, this.prepro_param);        
        else
            % Use the RGB image only                
            T{k}=this.preprocessing(datag.current_movie.M, this.prepro_param);
        end
    end
    L(k)=size(T{k},1); % size of the preprocessed data can be different from that of the movie
end

% Set the average gesture length
this.segment_param=mean(L);   

%%%%% Perform Principal Components Analysis
for k=1:Ntr
    Tmdl{k}.a = pc_compute( T{k}, this.pcs );   
end

% Reorder the templates so we don't have to worry
y=get_Y(datag, 'all');
[s, idx]=sort([y{:}]);
this.T=T(idx);
this.OCM=Tmdl(idx); 

% Eventually  test the this
if this.test_on_training_data
    resu=test(this, datag);
else
    resu=result(datag); % Just make a copy
end

if this.verbosity>0, fprintf('\n==TR> Done training %s for movie type %s...\n', class(this), this.movie_type); end


