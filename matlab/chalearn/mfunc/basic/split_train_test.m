function [train_labels, train_samples, test_labels, test_samples]=split_train_test(labels, samples)
%[train_labels, train_samples, test_labels, test_samples]=split_train_test(labels, samples)
% Split a dataset according to training and test set

type=[];
set=[];


for k=1:length(samples)
    if samples(1)>10000
        [type(k), set(k), num(k)]=split_id(samples(k));
    else
        num(k)=samples(k);
        type(k)=1;
        set(k)=1;
    end
end

    

train_labels=[];
train_samples=[];
test_labels=[];
test_samples=[];

tlist=unique(type);
slist=unique(set);

for t=tlist
    for s=slist
        idx=intersect(find(type==t), find(set==s));
        uval=unique([labels{idx}]);
        idxtr=intersect(idx, find(num<=length(uval)));
        idxte=intersect(idx, find(num>length(uval)));
        train_labels=[train_labels, labels(idxtr)];
        train_samples=[train_samples, samples(idxtr)];
        test_labels=[test_labels, labels(idxte)];
        test_samples=[test_samples, samples(idxte)];
    end
end

            