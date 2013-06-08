%==========================================================================
% DTW_PREPRO object             
%==========================================================================
% a=dtw_prepro(hyper) 
%
% Performs preprocessing and segmentation with Dynanic Time Warping.
% The preprocessing function is passed as a hyperparameter as a handle to a
% function. The test method splits the frame sequence and fills in the
% property "cuts" of the data object (of type "result"), which contains the
% begining and end of each cut segment.
% See the parent class dtw_recog for details.
%
% The function performed is identical to dtw_recogn except that the
% preprocessing is returned in the "result", not the result of recognition.
% This is sometimes usefule because DTW can perform good segmentation and
% poor recognition. The "result" can then be fed to another recognizer.

%Isabelle Guyon -- isabelle@clopinet.com -- June 2012

classdef dtw_prepro < dtw_recog

    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = dtw_prepro(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            a=a@dtw_recog(hyper);
            a.use_as_prepro=1;
        end  
    end %methods
end %classdef
  

 

 
 





