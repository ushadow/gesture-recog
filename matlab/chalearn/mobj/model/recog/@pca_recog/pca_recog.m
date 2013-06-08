%==========================================================================
% PCA_RECOG PCA Reconstruction using a time dependent feature representation             
%==========================================================================
% a=pca_recog(hyper) 
%
% This recognizer operates on PREPROCESSED data (as a series of frame
% features), which are temporally segmented, supplied by a "result" data object.
% However, a preprocessing and segmenter can be passed to make it operate
% on raw movies. The preprocessing is IGNORED if the data representation used 
% of type "result" and not "databatch" (because preprocessing is assumed to
% be done). The segmenter is IGNORED if the "cuts" property is not empty.
% 
% Frames in test-videos (in a feature rep) are projected into the PCA space
% of each gesture training example and reconstructed. 
% Classification is performed according to the smallest reconstruction
% error.
% The feature representation also needs to be segmented.
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
% my_model=pca_recog; % all default
% my_model=pca_recog('pcs=20'); % use 20 principal components
% my_model=pca_recog({'movie_type=''M''', 'prepro_param=0.10'}); % Use RGB movies (otherwise movie_type='K')
% my_model=pca_recog({'verbosity=1', 'test_on_training_data=1'});
% my_model=pca_recog('preprocessing=@(x) motion(x, 9)'); % this fixes the parameter of preprocessing
% my_model=pca_recog({'preprocessing=motion', 'prepro_param=9'}); % this does the same

%Hugo Jair Escalante -- http://hugojair.org/ -- May 2012
%Isabelle Guyon -- isabelle@clopinet.com -- October 2011-May 2012

classdef pca_recog
	properties (SetAccess = public)
        % Hyperparameters
        pcs=10;                           % Number of principal components to consider
        movie_type='K';                   % A choice of 'M' for the RGB image or 'K' for the depth image
        verbosity=0;                      % Flag to turn on verbose mode for debug
        test_on_training_data=0;          % Flag to turn on training data

        preprocessing=@motion_histograms; % Default preprocessing used only 
                                          % if the data comes as a databatch 
                                          % instead of preprocessed data
        segmenter=@equal_segments;        % Default temporal segmentation
        prepro_param=0.05;                % Preprocessing parameter (Scaling factor of the image)
        segment_param=[];                 % Segmenter parameter (Average length of a single gesture)
    end
    properties (SetAccess = private)
        % Model parameters
        T={};                             % List of templates from training data
        OCM={};                           % PCA models
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = pca_recog(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
        function show(this, h)
            % Show the templates
            if nargin<2 || isempty(h)
                h=figure('name', 'pca_recog', 'Position', [22 49 1194 634]);
            else
                figure(h);
                clf;
            end
            hold on
            N=length(this.T);
            dim=ceil(sqrt(N));
            dim1=dim;
            for k=1:dim
                dim2=k;
                if N<dim1*dim2;
                    break;
                end
            end
            hold off
            for j=1:N
                subplot(dim1,dim2, j);
                im=this.T{j};
                mini=min(im(:));
                maxi=max(im(:));
                im=(im-mini)/(maxi-mini);
                imagesc(im);
                axis off
                axis image
                title(num2str(j));
            end
        end
        
    end %methods
end %classdef
  

 

 
 





