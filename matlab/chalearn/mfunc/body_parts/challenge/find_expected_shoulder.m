function shoulder = find_expected_shoulder(observed_face, face_mean, shoulder_face_cov, shoulder_mean, inverse_face_cov)

    shoulder = round( shoulder_mean + (shoulder_face_cov * inverse_face_cov * (observed_face - face_mean) ) );
    shoulder(1) = min( max(1, shoulder(1)), 240);
    shoulder(2) = min( max(1, shoulder(2)), 320);
    shoulder(3) = min( max(1, shoulder(3)), 255);
end