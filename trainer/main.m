#!/usr/bin/env octave

function main(iter_num=500, lambda=1)
    % 20x20 Input Images of Digits
    input_layer_size  = 400;
    hidden_layer_size = 25;

    train_dirpath = 'training_dataset';
    train_dataset = 'training_data.mat';
    thetas_saveto = 'thetas.mat';

    % load dataset
    if exist(train_dataset, 'file') == 2
        load(train_dataset);
    else
        fprintf('\nConverting images to a big matrix...\n');
        [X, Y] = imgs2mat(train_dirpath);
        save('-6', train_dataset, 'X', 'Y');
    end

    % predict or trainning
    if exist(thetas_saveto, 'file') == 2
        load(thetas_saveto)
        fprintf('\nPredicting...\n');
        pred = predict(Theta1, Theta2, X);
        fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Y)) * 100);
    else
        fprintf('\nTraining...\n');
        [Theta1, Theta2] = train(iter_num, lambda,
                                 X, Y,
                                 input_layer_size, hidden_layer_size,
                                 thetas_saveto);
        save('-6', thetas_saveto, 'Theta1', 'Theta2');
    end
end


args = argv();
if nargin < 1
    main();
elseif nargin == 1
    main(args{1})
elseif nargin == 2
    main(args{1}, args{2})
end