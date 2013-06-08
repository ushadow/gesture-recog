%==========================================================================
% CHAIN object             
%==========================================================================
% a=chain(hyper) 
%
% This is an object similar to a chain Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% A chain object allows chaining several preprocessings and a recognizer.
% my_chain = chain({prepro1, prepro2, recog});
% [resu, my_chain] = train(my_chain, training_data);
% resu = test(my_train, test_data);

%Isabelle Guyon -- isabelle@clopinet.com -- May 2012

classdef chain
	properties (SetAccess = public)
        % Here other hyperparameters of the preprocessing 
        % and trainable parameters can be declared
        models={};
        verbosity=0;            % Flag to turn on verbose mode for debug
        test_on_training_data=0;% Flag to turn on training data
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = chain(models, hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            a.models=models;
            if nargin>1 && ~isempty(hyper)
                eval_hyper;
            end
        end  
        
        function [resu, this] = train(this, data) 
            %[resu, this] = train(this, data) 
            if this.verbosity>0, fprintf('\n==TR> Training %s... ', class(this)); end
            if isempty(this.models), resu=[]; return, end
            this.models{1}.test_on_training_data=1;
            [resu, this.models{1}] = train(this.models{1}, data);
            for k=2:length(this.models)
                this.models{k}.test_on_training_data=1;
                [resu, this.models{k}] = train(this.models{k}, resu);
            end
            if this.verbosity>0, fprintf('\n==TR> Done training %s... ', class(this)); end
        end
        
        function [new_pat, new_cuts] = exec(this, pat, cuts)   
            %[new_pat, new_cuts] = exec(this, pat, cuts) 
            if isempty(this.models), new_pat=[]; new_cuts=[]; return, end
            %pp0=pat; cc0=cuts;
            [new_pat, new_cuts] = exec(this.models{1}, pat, cuts);
            for k=2:length(this.models)
                [new_pat, new_cuts] = exec(this.models{k}, new_pat, new_cuts);
            end
        end
        
        function [resu, this] = test(this, data)
            %[resu, this] = test(this, data)
            if this.verbosity>0, fprintf('\n==TE> Testing %s... ', class(this)); end
            resu=result(data);
            Nte=length(data);
            for k=1:Nte
                if this.verbosity>0,
                    if ~mod(k, round(Nte/10))
                        fprintf('%d%% ', round(k/Nte*100));
                    end
                end
                [X, cuts]=exec(this, get_X(data, k), get_cuts(data, k));
                set_X(resu, k, X);
                set_cuts(resu, k, cuts);
            end
            if this.verbosity>0, fprintf('\n==TE> Done testing %s... ', class(this)); end
        end
        
    end %methods
end %classdef
  

 

 
 





