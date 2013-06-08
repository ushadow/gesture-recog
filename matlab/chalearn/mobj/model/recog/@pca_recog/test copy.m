function resu = test(model, datag)
% Make predictions with a principal motion method. Performs
% PCA on the frames in each video from the vocabulary, storing the PCA
% models. Frames in test-videos are projected into the PCA space and
% reconstructed using each of the PCA models, one for each gesture in the
% vocabulary. Next we measure the reconstruction error for each of the
% models and assign a test video the gesture that obtains the lowest
% reconstruction error. 
% 
% Inputs:
% model -- A principal motion object.
% datag -- A data structure.
% Returns:
% data -- The same data structure. WARNING: this follows the convention of
% Spider http://www.kyb.mpg.de/bs/people/spider/ *** The result is in resu.X!!!! ***
% resu.Y are the target values.

% Isabelle Guyon -- October 2011 -- isabelle@clopinet.com
% Hugo Jair Escalante -- hugojair@inaoep.mx -- April, 2012

if model.verbosity>0, fprintf('\n==TE> Testing %s for movie type %s... ', class(model), model.movie_type); end

resu=result(datag);

% Loop over the samples (we also test the training samples)
Nte=length(datag);
for k=1:Nte
    if model.verbosity>0,
        if ~mod(k, round(Nte/10))
            fprintf('%d%% ', round(k/Nte*100));
        end
    end
    
    % Fetch the pattern
    if isa(datag, 'result')
        T=get_X(datag, k);
    else
        goto(datag, k);
        if strcmp(model.movie_type, 'K')
            K=datag.current_movie.K; % Focus on the depth image only
            %%%% Extract the motion histogram
            T=motion_histograms(K,model.scale);
        else
            K=datag.current_movie.M; % Focus on the RGB image only
            T=motion_histograms(K,model.scale);
        end
    end
    
    % Checks whether cuts exist
    cuts=get_cuts(datag, k);
    if isempty(cuts)
        cuts=model.segmenter(T, model.segment_param); % It should be length(T) not length(K)
        set_cuts(datag, k, cuts);
    end
    
    % Chop the movie in equal pieces and compute the average of the pieces
    Xb=split_pattern(T, cuts);
    
    % Compute the reconstruction error with the different PCA models and 
    % assign the label corresponding to the gesture with lowest
    % reconstruction error    
    N=length(Xb);
    Y=zeros(1,N);    
    for i=1:N % Number of gestures
        S=[];        
        for j=1:length(model.T),
            [p,n]=size(Xb{i});
            % % % % Project the data using the PCs for this model
            X=Xb{i}-model.OCM{j}.a.mu(ones(p,1),:);
            rX=X*model.OCM{j}.a.U;            
            % % % % Reconstruct the data with the j-th model and compute
            % % % % the reconstruction error
            v=mean(Xb{i});    
            R=rX*model.OCM{j}.a.pinvU+(v(ones(size(Xb{i},1),1), :));
            rerrr=(sum((R-Xb{i}).^2,2)).^0.5;
            c=mean(rerrr);                       
            S(j)=c;            
        end               
    [m, Y(i)]=min(S);    
    end
    set_X(resu, k, Y);
end

if model.verbosity>0, fprintf('\n==TE> Done testing %s for movie type %s... ', class(model), model.movie_type); end

return