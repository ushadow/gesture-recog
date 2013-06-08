function head_box = detect_head( im1, im2 )
%head_box = detect_head( im1, im2 )
% Wrapper function calling one method of head detection
% Work in progress...

if nargin<2
    face = detect_face(im1);
    head_box=[face.bounding_box.left, face.bounding_box.top, face.bounding_box.right-face.bounding_box.left, face.bounding_box.bottom-face.bounding_box.top];
else
    head_box=detect_head_(im1, im2);
end

end

