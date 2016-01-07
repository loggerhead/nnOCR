function [J grad] = nnCostFunction(nn_params,
                                   input_layer_size, hidden_layer_size,
                                   num_labels,
                                   X, y, lambda)
    split_index = hidden_layer_size * (input_layer_size + 1);
    Theta1 = reshape(nn_params(1:split_index), hidden_layer_size, input_layer_size + 1);
    Theta2 = reshape(nn_params((1 + split_index):end), num_labels, hidden_layer_size + 1);
    Thetas = {Theta1, Theta2};
    m = size(X, 1);

    As = {X};
    Zs = {zeros(size(X))};
    penalty = 0;
    layer_num = size(Thetas, 2) + 1;

    one = @(x) sum(eye(size(x, 1)))';
    h = @(t, x) sigmoid([one(x) x] * t');

    for i = 1:layer_num-1
        As{end} = [one(As{end}) As{end}];
        t = Thetas{i};
        Zs = [Zs; {As{end} * t'}];
        As = [As; {sigmoid(Zs{end})}];

        penalty += sum(sum(t(:,2:end).^2));
    end

    H = As{end};
    penalty *= lambda/(2*m);

    Y = zeros(size(y, 1), num_labels);
    Y(sub2ind(size(Y), (1:size(y, 1))', y)) = 1;

    J = sum(sum(-Y.*log(H) - (1-Y).*log(1-H))) / m;
    J += penalty;

    deltas{layer_num} = As{end} - Y;
    Deltas = {};

    for i = layer_num-1:-1:2
        delta = deltas{i+1};
        theta = Thetas{i};

        deltas{i} = (delta * theta)(:,2:end) .* sigmoidGradient(Zs{i});
        Deltas{i} = deltas{i+1}' * As{i};
    end
    Deltas{1} = deltas{2}' * As{1};

    grad = [];
    for i = 1:layer_num-1
      theta = Thetas{i};
      theta(:,1) = 0;
      theta_grad = Deltas{i} / m + lambda/m * theta;
      grad = [grad(:); theta_grad(:)];
    end
end