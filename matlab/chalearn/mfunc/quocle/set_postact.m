function postact = set_postact(gpu)

%% ---------------- post activation threshold/normalization ----------------
% fix thresholds on neural activations
postact.layer1.type = 'lhthresh';
postact.layer1.lowthresh = 0;
postact.layer1.highthresh = 1;

postact.layer2.type = 'lhthresh';
postact.layer2.lowthresh = 0;
postact.layer2.highthresh = 1;

if(gpu)
    postact.layer1.gpu = 1;
    postact.layer2.gpu = 1;
end