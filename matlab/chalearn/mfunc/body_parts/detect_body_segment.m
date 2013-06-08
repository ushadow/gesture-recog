function body_segment = detect_body_segment(depth_frame, face, parameters)
% body_contour = get_full_body_contour(depth_frame, face, parameters)
% Get body contour image of the given depth image (including face)
% 
% Arguments
% depth_frame -- depth frame image
% face -- face struct of a particular image
% parameters -- (optional) algorithm parameters, if not specified, will return the value based on the given frame
% 
% Return -- body contour image
% 
% Usage sample
%     K0 = read_movie('devel01/K_1.avi');
%     body_segment = detect_body_segment(K(0).cdata);

% Author: Pat Jangyodsuk and Vassilis Athitsos -- November 2011

if (ndims(depth_frame) == 3)
    depth_frame = double( mean(depth_frame,3) );
end

if (nargin < 3)
    parameters = set_parameters(depth_frame);
    if (nargin == 1)
        face = detect_face(depth_frame, parameters); 
    end

end

body_segment = segment_body(depth_frame, face, parameters);
body_segment = body_segment .* depth_frame;

end