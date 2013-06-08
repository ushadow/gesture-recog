function result_index = nearest_neighbor(data, query1, query2)
    
    min_diff = bitmax;
   
    normalized_vector = [240 320 255 240 320 255]';
    query1= query1 ./ normalized_vector;
    query2= query2 ./ normalized_vector;
    for i=1:size(data, 2)
        diff1 = euclidean_distance(data(:, i), query1);
        diff2 = euclidean_distance(data(:, i), query2);
        diff = min(diff1, diff2);
        if (diff < min_diff)
           min_diff = diff;
           if (diff1 < diff2)
              result_index = 1;
           else
               result_index = 2;
           end
        end
    end
    
    
end