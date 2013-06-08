function Xsvm = formhist_stackisa(label_all, indices, params, MM, num_clips, ini_idx)

if params.usenormbin == 0
    %%------------------ form svm inputs by binning ----------------------    

    Xsvm = zeros(num_clips, params.num_centroids);
    for i = 1:params.num_vid_sizes
        Xsvm = Xsvm + buildtmppyd(label_all{ini_idx}{i}, indices{i}, num_clips, params.num_centroids, params.pydheight);
    end    

else

    for i = 1:params.num_vid_sizes
        MM_norm{i} = MM{i};
        MM_norm{i} = max(0, MM_norm{i}-params.filtermotion);
        MM_norm{i} = (MM_norm{i}/2400).^params.normbinexp;
    end
    
    %%%%%%%%%%%%%%%%% use buildtmppyd to build histograms %%%%%%%%%%%%%%%%%
    num_blocks = 2^params.pydheight-1;

    Xsvm = zeros(num_clips, params.num_centroids*num_blocks);
    for i = 1:params.num_vid_sizes  

       Xsvm = Xsvm + buildtmppyd(label_all{ini_idx}{i}, indices{i}, num_clips, params.num_centroids, params.pydheight, MM_norm{i});

    end    
end
   
end
