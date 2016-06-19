function densemapCrop(datasetFolderDir, testSeq, densemapN, cropSize, forwardSize)
  % Params
  count = 1;

  % Read image
  for index = 1:numel(testSeq)
    disp(['Processing: ', testSeq{index}]);
    
    % Load image directory
    satelliteAll =  imread(strcat(datasetFolderDir, testSeq{index}, '/satelliteRaw_Big.png'));

    % Size of image
    [rowSize, colSize, ~] = size(satelliteAll);% Be careful. RGB!

    % Open txt file
    parmTxt = fopen(strcat(datasetFolderDir, testSeq{index}, '/denseMapParmLog.txt'),'wt');

    % Rm dir for preventing overlapping images from previous trials
    if exist(strcat(datasetFolderDir, testSeq{index}, '/densemap_v2'), 'dir') == 7
      rmdir(strcat(datasetFolderDir, testSeq{index}, '/densemap_v2'), 's');
    end

    % mkdir
    mkdir(strcat(datasetFolderDir, testSeq{index}, '/densemap_v2'))

    % Set margin
    margin = ceil(forwardSize*sqrt(2));

    % Randomly choose coordinates & orientation for densemapN times
    while count <= densemapN
        row = round(rand(1) * rowSize);
        col = round(rand(1) * colSize);
        ori = round(rand(1) * 360);% In degrees

        % Check margin
        if (row+margin <= rowSize) && (col+margin <= colSize) && (row-margin >= 1) && (col-margin >= 1)
            % IBig
            IBig = satelliteAll(row-margin:row+margin, col-margin:col+margin, :);

            % IRot
            IRot = imrotate(IBig, ori);

            % IFin
            [tmpRowSize, tmpColSize, ~] = size(IRot);
            yBegin = tmpRowSize/2-forwardSize;
          	yEnd = tmpRowSize/2+(cropSize-forwardSize)-1;
          	xBegin = tmpColSize/2-round(cropSize/2);
          	xEnd = tmpColSize/2+round(cropSize/2)-1;

            IFin = IRot(yBegin:yEnd, xBegin:xEnd, :);

            % Save
            imwrite(IFin, strcat(datasetFolderDir, testSeq{index}, '/densemap_v2/', num2str(count), '.png'));

            fprintf(parmTxt, [num2str(row), ' ', num2str(col), ' ', num2str(ori), '\n']);

            count = count+1;
        end
    end

    count = 1;
  end

  % Close txt file
  fclose(parmTxt);
  disp('... densemapCrop complete');
end
