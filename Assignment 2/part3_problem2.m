%% Preliminary stuff
clc, close all force, clear all;

%% Load data
f = fopen('OlympicData.txt', 'rb');

reg1 = '(?<year>\d\d\d\d)';
reg2 = '(?<first>\w+)\s+(?<last>\w+(-\w+)?)\s+\((?<country>.*)\)';
reg3 = '(?<time>\d+\.\d+)';

men = []; women = {};

line = fgetl(f);
isman = true;
while line ~= -1
    parsed = regexp(line, reg1, 'names');
    if ~isempty(parsed)
        year = str2double(parsed.year);
        isman = true;
    end
    
    parsed = regexp(line, reg2, 'names');
    if ~isempty(parsed)
        name = [parsed.first ' ' parsed.last ' (' parsed.country ')'];
    end
    
    parsed = regexp(line, reg3, 'names');
    if ~isempty(parsed)
        time = str2double(parsed.time);
        if isman
            if isempty(men)
                men = {year,name,time};
            else
                men = [men;{year,name,time}];
            end
            isman = false;
        else
            if isempty(women)
                women = {year,name,time};
            else
                women = [women;{year,name,time}];
            end
            isman = true;
        end
    end
    
    line = fgetl(f);
end

fclose(f);

%% Calculate linear models that minimize squared error

years_men = cell2mat(men(:,1)); years_women = cell2mat(women(:,1));
times_men = cell2mat(men(:,3)); times_women = cell2mat(women(:,3));

% for men (recall B = (X'X)^-1 (X'Y) )
X1 = [years_men, ones(length(years_men),1)]; Y1 = times_men;
B1 = (X1'*X1)\(X1'*Y1);
f1 = @(x) B1(1)*x + B1(2);

% for women
X2 = [years_women, ones(length(years_women),1)]; Y2 = times_women;
B2 = (X2'*X2)\(X2'*Y2);
f2 = @(x) B2(1)*x + B2(2);

%% Plot

min_time = min(years_men) - 10; max_time = max(years_men) + 10;

figure; hold on;
plot(years_men, times_men, 'ok', 'linewidth', 2);
plot([min_time,max_time], f1([min_time,max_time]), '--r', 'linewidth', 2);

title('Men''s Sprinting Gold Medal Winning Times');
xlabel('Year'); ylabel('Time');
legend('Actual Times', 'Fit Line');

min_time = min(years_women) - 10; max_time = max(years_women) + 10;

figure; hold on;
plot(years_women, times_women, 'ok', 'linewidth', 2);
plot([min_time,max_time], f2([min_time,max_time]), '--r', 'linewidth', 2);

title('Women''s Sprinting Gold Medal Winning Times');
xlabel('Year'); ylabel('Time');
legend('Actual Times', 'Fit Line');

%% Predict winners for 2016 and 2020

display(['Prediction for men: 2016 -> ' num2str(f1(2016)) ', 2020 - > ' num2str(f1(2020))]);
display(['Prediction for women: 2016 -> ' num2str(f2(2016)) ', 2020 - > ' num2str(f2(2020))]);


%% Predict when women will surpass men

% find time the two line intersect and take ceiling of number to find next
% number, then find next year that's a multiple of 4.
women_year = ceil(fzero(@(x) f1(x) - f2(x), 2016));
women_year = women_year + (4 - (mod(women_year,4)));
display(['Women will surpass men in the ' num2str(women_year) ' Olympic games according to this model.']);
display(['They will win with a time of ' num2str(f2(women_year)) '.']);

%% Calculate R^2 for both models

res_men = times_men - f1(years_men);
res_women = times_women - f2(years_women);

R2_men =  1 - sum(res_men.^2,1) / sum((times_men - mean(times_men)).^2,1);
R2_women = 1 - sum(res_women.^2,1) / sum((times_women - mean(times_women)).^2,1);

display(['R^2 for men: ' num2str(R2_men) '.']);
display(['R^2 for women: ' num2str(R2_women) '.']);

%% Plot residuals

figure,
plot(years_men, res_men, 'ok', 'linewidth', 2);
title('Residuals for the fit for the men''s data');
xlabel('Year'); ylabel('Residuals');

figure,
plot(years_women, res_women, 'ok', 'linewidth', 2);
title('Residuals for the fit for the women''s data');
xlabel('Year'); ylabel('Residuals'); 
