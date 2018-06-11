%plot mses
function plotMSE(path)
    mses = csvread(path);
    mses = mses(:,1:end-1);
    for i = 1:size(mses, 1)
        figure
        mse = reshape(mses(i,:),10,10)';
        surf(mse);
        xticklabels(10.^((1:10)-5));
        yticklabels(1e-8*(10.^((1:10)-5)));
        xlabel('R scale');
        ylabel('Q scale');
        set(gca, 'ZScale', 'log')
        title(num2str(i));
        colorbar
    end
end