function [type, set, num, valid]=split_id(sampleid)
%[type, set, num, valid]=split_id(sampleid)

    valid=1;
    type=[];
    set=[];
    num=[];
    
    snum=num2str(sampleid);
    if isempty(snum)
        valid=0;
        return
    end
    type=str2num(snum(1));
    snum=snum(2:end);
    if length(snum)<2
        valid=0;
        return
    end
    set=str2num(snum(1:2));
    snum=snum(3:end);
    if length(snum)<2
        valid=0;
        return
    end
    num=str2num(snum(1:2));
    if type<1 || type>2, % must be a validation or final example
        valid=0;
    elseif set<1 || set>40 || round(set)~=set
        valid=0;
    elseif num<1 || num>47 || round(num)~=num
        valid=0;
    end
        
end