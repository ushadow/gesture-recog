function resu = test(model, data)
%resu = test(model, data)
% Make predictions with a template matching recognizer.
% Inputs:
% model -- A recog_template object.
% data -- A data structure.
% Returns:
% resu -- A result data structure. WARNING: this follows the convention of
% Spider http://www.kyb.mpg.de/bs/people/spider/ *** The result is in resu.X!!!! ***
% resu.Y are the target values.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if model.verbosity>0, fprintf('\n==TE> Testing %s... ', class(model)); end

resu=result(data);

% Loop over the samples 
Nte=length(data);
for k=1:Nte
    % Monitor progress
    if model.verbosity>0,
        if ~mod(k, round(Nte/10))
            fprintf('%d%% ', round(k/Nte*100));
        end
    end
    
    % Compute the recognition result
    Y=exec(model, get_X(data, k));
    set_X(resu, k, Y);
end

if model.verbosity>0, fprintf('\n==TE> Done testing %s... ', class(model)); end
