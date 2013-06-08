%==========================================================================
% DTW_SEGMENT object             
%==========================================================================
% a=dtw_segment(hyper) 
%
% Performs segmentation with Dynamic Time Warping.
% The preprocessing function is passed as a hyperparameter as a handle to a
% function. The test method splits the frame sequence and fills in the
% property "cuts" of the data object (of type "result"), which contains the
% begining and end of each cut segment.
% See the parent class dtw_recog for details.
%
% The function performed is identical to dtw_recogn except that the
% original data object , not the result of recognition or preprocessing.
% This is sometimes usefule because DTW can perform good segmentation and
% poor recognition or preprocessing. 
% The "result" can then be fed to another preprocessing or recognizer.

%Isabelle Guyon -- isabelle@clopinet.com -- June 2012

classdef dtw_segment < dtw_recog

    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = dtw_segment(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            if nargin<1, hyper=[]; end
            
            a=a@dtw_recog(hyper);
            a.use_as_segmenter=1;
        end  
    end %methods
end %classdef
  

 

 
 





