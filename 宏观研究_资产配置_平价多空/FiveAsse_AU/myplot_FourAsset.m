function []= myplot_FourAsset(AssetAll,AssetData,theWeights)
%净值曲线图

asset = cell2mat(AssetAll(2:end,5));
assetNet = asset/asset(1);
tradingdays = AssetAll(2:end,1);
T=datenum(tradingdays,'yyyy-mm-dd');
subplot(2,2,1), plot(T,assetNet,'b');
xlabel('净值曲线图')
datetick('x','yy-mm','keepticks');
grid on;

%资产配置比例图
subplot(2,2,2), area(T,abs(cell2mat(theWeights(2:end,2:end))),...
    'DisplayName','T,cell2mat(theWeights(2:end,2:end))')
xlabel('资产比例配置图')
datetick('x','yy-mm','keepticks');
legend('A股','商品期货','港股','纳指','国债');
grid on;

%累计收益图
m = size(AssetData,2);
n = size(AssetData{1,1},1)-1;
cumsums = zeros(n,m);
for i = 1:m
    cumsum_pnlh = cumsum(cell2mat(AssetData{1,i}(2:end,3)));
    cumsum_pnlt = cumsum(cell2mat(AssetData{1,i}(2:end,4)));
    cumsums(:,i) = cumsum_pnlh + cumsum_pnlt;
end
subplot(2,2,3),plot(T,cumsums(:,1),T,cumsums(:,2),T,cumsums(:,3),T,cumsums(:,4),T,cumsums(:,5))
xlabel('累计收益图')
datetick('x','yy-mm','keepticks');
legend('A股','商品期货','港股','纳指','国债');
grid on;
end