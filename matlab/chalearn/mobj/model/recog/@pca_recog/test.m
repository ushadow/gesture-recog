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

    [X, cuts]=exec(model, get_X(datag, k), get_cuts(datag, k));
    set_X(resu, k, X);
    set_cuts(resu, k, cuts);
end

if model.verbosity>0, fprintf('\n==TE> Done testing %s for movie type %s... ', class(model), model.movie_type); end

return