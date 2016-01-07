function cutImage(imgpath, saveto)
    imagen = imread(imgpath);
    % Convert to gray scale
    if size(imagen, 3) == 3
        imagen = rgb2gray(imagen);
    end

    % Convert to BW
    threshold = graythresh(imagen);
    imagen = im2bw(imagen, threshold);
    imshow(imagen);
    [row, col] = size(imagen);

    if sum(sum(imagen)) > row*col / 2
        imagen = ~imagen;
    end

    % Remove all object containing fewer than 30 pixels
    imagen = bwareaopen(imagen, 30);
    [L Ne] = bwlabel(imagen);
    imagen = double(imagen);

    k = 0;
    for n = 1:Ne
        [r, c] = find(L == n);
        % Extract letter
        row = (min(r) + max(r)) / 2;
        col = (min(c) + max(c)) / 2;

        n1 = imagen(min(r):max(r), min(c):max(c));
        [rown1, coln1] = size(n1);

        if rown1 > coln1
            img_r = logical(imresize(n1, [20 20]));
            filename = strcat(num2str(k), '_', num2str(row), '_', num2str(col), '.bmp');
            filepath = fullfile(saveto, filename);
            imwrite(img_r, filepath);
            k += 1;
        end
    end
end