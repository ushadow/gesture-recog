function result_index = find_hand_and_elbow(location1, location2, parameters)
    prior_knowledge = parameters.prior_knowledge;
    hypothesis1 = [location1(1), location1(2), location1(3), location2(1), location2(2), location2(3)]';
    hypothesis2 = [location2(1), location2(2), location2(3), location1(1), location1(2), location1(3)]';
    result_index = nearest_neighbor(prior_knowledge, hypothesis1, hypothesis2);
    

end