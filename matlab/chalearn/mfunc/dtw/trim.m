function motion = trim( motion )
%motion = trim( motion )
% motion is a data representation, features in columns, time in lines
% in which each feature indicates motion in a part of the image
% Trims the beginning and end where there is not a lot of motion

% Isabelle Guyon -- guyon@clopinet.com -- May 2012

mot=median(motion, 2);
mx=max(mot);
mn=min(mot);
th=(mx-mn)/3;

i0=1;
for k=1:length(mot)
    if mot(k)>th
        i0=k;
        break;
    end
end
in=length(mot);
for k=length(mot):-1:1
    if mot(k)>th
        in=k;
        break;
    end
end

motion=motion(i0:in, :);


end

