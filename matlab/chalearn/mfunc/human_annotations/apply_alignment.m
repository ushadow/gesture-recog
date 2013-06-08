function result_image = apply_alignment(rgb_frame, depth_frame, translate_x, translate_y, scale_x, scale_y)
% result_image = apply_alignment(rgb_frame, depth_frame, translate_x, translate_y, scale_x, scale_y)
% Visualize the alignment of color and depth frame given alignment
% arguments
% Return result_image: the alignment result image
% Arguments:
%   - rgb_frame - color image
%   - depth_frame - corresponding depth image
%   - translate_x - x translation (apply on depth frame)
%   - translate_y - y translation (apply on depth frame)
%   - scale_x     - x scale (apply on depth frame)
%   - scale_y     - y scale (apply on depth frame)
    if (ndims(depth_frame) == 3)
       depth_frame = mean(depth_frame, 3); 
    end
    
    % get body segment
    parameters = set_parameters(depth_frame);
    face = detect_face(depth_frame, parameters);
    body_segment = segment_body(depth_frame, face, parameters);
    
    % resize the template according to given scale_x, scale_y
    resized_template = imresize(body_segment, [round(scale_y * 240), round(scale_x * 320)], 'bilinear');

    translated_template = zeros(240,320);
    
    translate_x=round(translate_x);
    translate_y=round(translate_y);
    
    top = 1+translate_y;
    left =  1+translate_x;
    
    template_top =  -translate_y;
    template_left =  -translate_x;
    
    % make sure the resized body segment size is (240, 320) by chopping off
    % out of boundary area
    resized_template2 = zeros(240,320);
    resized_template2(1:min(240, size(resized_template,1)), 1:min(320, size(resized_template,2)) ) = ...
               resized_template(1:min(240, size(resized_template,1)), 1:min(320, size(resized_template,2)) );
      
    % translate the template
    translated_template( max(1, top):min(240, top + 240 ) , max(1, left):min(320, left + 320 ) ) ...
            = ...
            resized_template2( max(1, template_top):min(240, template_top + 240 ) , max(1, template_left):min(320, template_left + 320 ) );
    
    % overlay the template on top of color image
    result_image = zeros(240,320);
    for i=1:3
        result_image(:,:,i) = double(rgb_frame(:,:,i)) .* translated_template;
    end
    mask = (translated_template == 0);
    green = result_image(:,:,2);
    green(mask) = 100;
    
    result_image(:,:,2) = green;

end