function g = sigmoidGradient(z)
    G = sigmoid(z);
    g = G .* (1-G);
end