function [Theta1, Theta2] = train(max_iter, lambda,
                                  X, Y,
                                  input_layer_size, hidden_layer_size,
                                  thetas_saveto)
    num_labels = max(Y);
    m = size(X, 1);
    initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
    initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
    initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];
    options = optimset('MaxIter', max_iter);

    fprintf('\nTraining...\n');
    costFunction = @(p) nnCostFunction(p, ...
                                       input_layer_size, ...
                                       hidden_layer_size, ...
                                       num_labels, X, Y, lambda);

    [nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

    Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                     hidden_layer_size, (input_layer_size + 1));
    Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                     num_labels, (hidden_layer_size + 1));

    save(thetas_saveto, 'Theta1', 'Theta2');
end