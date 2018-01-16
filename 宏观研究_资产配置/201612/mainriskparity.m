Data = getindexdata('2010-11-02', '2017-01-11', [{'000300.SH'},{'NH0100.NHF'}]);
%Data = getindexdata('2010-11-02', '2017-01-11', [{'000300.SH'},{'NH0100.NHF'},{'0372.CS'}]);
%% 读取国债数据
feature('DefaultCharacterSet', 'UTF8');%使得matlab能够识别utf8
fid = fopen('D:/001Work/宏观研究_资产配置/201612/data/10年期国债收益率.txt','r');
info = textscan(fid, '%s%f','HeaderLines',0,'Delimiter',',');%textscan的Name-Value Pair Arguments方法，跳过开始的1行，以','为分隔符,info每个cell为1列
fclose(fid);
%读取国债数据，合成Data品种的一部分
tradingdays = info{1,1};
treasurycls = num2cell(info{1,2});

%onedata和wind接口取得数据的日期不一致，相互都有不一致的日期
%寻找不同日期并在onedata里删除
ddt = Data{1,1};
tdays = ddt(2:end,1);
daydiff = setdiff(tradingdays, tdays); %找到wind接口中没有的日期
% Lia = ismember(A,B) returns an array containing 1 (true) where the ...
% data in A is found in B. Elsewhere, it returns 0 (false).
vectorfind = find(ismember(tradingdays,daydiff)==1);
tradingdays(vectorfind) = [];
treasurycls(vectorfind) = [];%删除

%剔除后的tradingdays在tdays中的位置
vectorfind2 = find(ismember(tdays,tradingdays)==1);
tdays2 = tdays;
treasurycls2 = zeros(size(tdays2,1),size(tdays2,2));
treasurycls2(vectorfind2) = cell2mat(treasurycls);%在相应位置上赋值

%滚动填充0值
prebox = 0;
n = length(treasurycls2);
for i = 1:n
    if treasurycls2(i) == 0
        treasurycls2(i) = prebox;
    else
        prebox = treasurycls2(i);
    end
end

%合成Data的一部分
contract = cell(size(tdays2,1),1);
contract(:,1) = {'treasury'};
onedata = [tdays2, contract, num2cell(treasurycls2)];
onedata = [{'TradingDay'},{'Contract'},{'Close'};onedata];
%合并到Data中
Data = [Data,{onedata}];
%% 风险评价策略
[pnldata, Assetall, Cumsums, weights ] = strategyriskprityandcomputeasset( '2011-02-01', ...
                            '2017-01-11', 60, 30000*10000, Data, names);
[ output ] = Performance( Assetall );

%Plot_Animation_Net(output);