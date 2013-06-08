function a = get_angle( s, c, degree )
%a = get_angle( s, c, degree )
% Get an angle from its sine and cosine.
% By default is radian.
% In degrees if degree==1.

%Isabelle Guyon -- isabelle@clopinet.com -- April 2012

if nargin<3, degree=0; end

if degree
    a=sign(s).*acosd(c);
else
    a=sign(s).*acos(c);
end

a=real(a);
end

