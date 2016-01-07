function [X, Y] = imgs2mat(dirpath)
    X = [];
    Y = [];

    imgpaths = glob(strjoin({dirpath, '/*.bmp'}, ''));

    for i = 1:size(imgpaths, 1)
        imgpath = imgpaths{i, 1};
        [dirname, filename, fileext] = fileparts(imgpath);
        label = strsplit(filename, '_'){1} - '0' + 1;
        imgmat = double(imread([imgpath]))(:)';

        X = [X; imgmat];
        Y = [Y; label];
    end
end