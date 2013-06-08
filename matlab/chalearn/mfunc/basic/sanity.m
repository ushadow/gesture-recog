function t=sanity(samples)
%t=sanity(samples)

t=1;
if length(unique(samples))~=length(samples)
    fprintf('** Repeated lines **\n');
    t=0;
    return
end

for k=1:length(samples)
    [type, set, num, valid]=split_id(samples(k));
    if ~valid
        fprintf('** Invalid sample inserted **\n');
        t=0;
        return
    end
end
