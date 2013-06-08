%==========================================================================
% BASIC_RECOG recognizer             
%==========================================================================
% a=basic_recog(hyper) 
%
% Super simple recognizer

%Isabelle Guyon -- isabelle@clopinet.com -- October 2011-June 2012



classdef basic_recog < chain

    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = basic_recog(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            if nargin<1, hyper=[]; end
            seg=basic_segment(hyper);
            prepro=basic_prepro(hyper);
            recog=template_matching(hyper);
            a=a@chain({seg, prepro, recog}, hyper);
        end  
    end %methods
end %classdef
  

 

 
 





