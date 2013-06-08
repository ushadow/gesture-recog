%==========================================================================
% PRINCIPAL_MOTION recognizer             
%==========================================================================
% a=principal_motion(hyper) 
% The underlying idea is to perform:
% 1) A severe downsizing of the image and the computation of differences
% 2) PCA on the frames in each video from the vocabulary, storing the PCA
% models. Frames in test-videos are projected into the PCA space and
% reconstructed using each of the PCA models, one for each gesture in the
% vocabulary. Next we measure the reconstruction error for each of the
% models and assign a test video the gesture that obtains the lowest
% reconstruction error. 
% 
% This is an object similar to a Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% All recognizers (called "model") must have at least 2 methods: train and test
% [resu, model]=train(model, data)
% resu = test(model, data)
% 
% Hyperparameters:
% The contructor can be called with hyperparameters, all of which have
% default values. For example:
% my_model=principal_motion; % all default
% my_model=principal_motion('pcs=20'); % use 20 principal components
% my_model=principal_motion('movie_type=''M'''); % Use RGB movies (otherwise movie_type='K')
% my_mode=principal_motion('scale=0.10'); % reduce the image to 10% its original size
% Use brackets to specify several HPs at a time.
% my_model=principal_motion(({'verbosity=1', 'test_on_training_data=1'}); 

%Hugo Jair Escalante -- http://hugojair.org/ -- May 2012
%Isabelle Guyon -- isabelle@clopinet.com -- October 2011-May 2012

classdef principal_motion < chain

    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = principal_motion(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            if nargin<1, hyper=[]; end
            seg=basic_segment(hyper);
            prepro=motion_prepro(hyper);
            recog=pca_recog(hyper);
            a=a@chain({seg, prepro, recog}, hyper);
        end  
    end %methods
end %classdef
  

 

 
 





