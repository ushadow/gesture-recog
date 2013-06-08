%==========================================================================
% MOTION_PREPRO Preprocessing template object             
%==========================================================================
% a=motion_prepro(hyper) 
%
% This preprocessing converts a video into a sequence of feature vectors,
% one per frame. Each feature vector includes average motion in a grid on
% the image. To that end, the image is rescaled by a given scaling factor.
% The Matlab function imresize is used to rescale the image.
%
% This is an object similar to a Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% All preprocessing objects (called prepro) must have at least 3 methods: train, test, and exec
% [resu, trained_prepro]=train(prepro, databatch)
% resu = test(prepro, databatch)
% preprocessed_representation = exec(prepro, movie)

%Isabelle Guyon -- isabelle@clopinet.com -- May 2012

classdef motion_prepro
	properties (SetAccess = public)
        % Here other hyperparameters of the preprocessing 
        % and trainable parameters can be declared
        movie_type='K';         % A choice of 'M' for the RGB image or 'K' for the depth image
        scale=0.05;             % Scaling factor of the image
        verbosity=0;            % Flag to turn on verbose mode for debug
        test_on_training_data=0;% Flag to turn on training data
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = motion_prepro(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
        function show(this, h)
            % Show something interesting about the parameters
            if nargin<2 || isempty(h)
                h=figure('name', 'prepro_template', 'Position', [22 49 1194 634]);
            else
                figure(h);
                clf;
            end
            hold on
            % Here some code...
        end
        
    end %methods
end %classdef
  

 

 
 





