function resu = test(this, data)
%resu = test(this, data)
% Make predictions with a recog_template method.
% Inputs:
% this -- A preprocessing object.
% data -- A data structure.
% Returns:
% resu -- A result data structure. WARNING: this follows the convention of
% Spider http://www.kyb.mpg.de/bs/people/spider/ *** The result is in resu.X!!!! ***
% resu.Y are the target values.

% Isabelle Guyon -- October 2011 -- isabelle@clopinet.com

if this.verbosity>0, fprintf('\n==TE> Testing %s for movie type %s... ', class(this), this.movie_type); end

% Here we don't touch the data
resu=data;

Nte=length(data);
for k=1:Nte
    if this.verbosity>0,
        if ~mod(k, round(Nte/10))
            fprintf('%d%% ', round(k/Nte*100));
        end
    end
    [~, cuts]=exec(this, get_X(data, k));
    set_cuts(resu, k, cuts);
end

if this.verbosity>0, fprintf('\n==TE> Done testing %s for movie type %s... ', class(this), this.movie_type); end
