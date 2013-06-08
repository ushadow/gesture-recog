%==========================================================================
% TEMPLATE_MATCHING Recognizer object             
%==========================================================================
% a=template_matching(hyper) 
%
% This is an object similar to a Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% This object can be chained with preprocessing objects returning a "result"
% object. 
%
% All recognizers (called "model") must have at least 2 methods: train and test
% [resu, model]=train(model, data)
% resu = test(model, data)

%Isabelle Guyon -- isabelle@clopinet.com -- May 2012

classdef template_matching
	properties (SetAccess = public)
        similarity=@any_simil;    % Similarity measure between patterns
	simil_param='euclid2';    % Eventual similarity measure HP
        return_only_scores=0;     % If 1, returns the scores for all classes rather than the class label
        len=[];                   % Average length of a single gesture
        X=[];                     % Templates from training data, features in columns, patterns in lines
        verbosity=0;              % Flag to turn on verbose mode for debug
        test_on_training_data=0;  % Flag to turn on training data
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = template_matching(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
        function [scores, cuts] = exec(this, pattern, cuts)
            if nargin<2, cuts=[]; end
            scores=this.similarity(this.X, pattern, this.simil_param);
            if ~this.return_only_scores
                [m, scores]=max(scores);
            end
        end
        
        function show(this, h)
            % Show the templates
            if nargin<2 || isempty(h)
                h=figure('name', 'recog_template', 'Position', [22 49 1194 634]);
            else
                figure(h);
                clf;
            end
            imdisplay(this.T);
        end
        
    end %methods
end %classdef
  

 

 
 





