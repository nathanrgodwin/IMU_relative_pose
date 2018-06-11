%plot mses
function plotMSE(path)
    mses = csvread(path);
    mses = mses(:,1:end-1);
    for i = 1:size(mses, 1)
        figure
        mse = reshape(mses(i,:),10,10)';
        contour([1:10:100], [1:10:100]*0.0001, mse);
        xlabel('R scale');
        ylabel('Q scale');
        title(num2str(i));
    end
end