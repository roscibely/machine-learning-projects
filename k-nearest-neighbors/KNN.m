%KNN Classifier 
clear;
close all;
clc;

K = 9; %Value for K

%%Read the file
file = 'dados.txt';
date = dlmread(file, ',');

%%Normalization
prompt = 'Do you want apply normalization? Y/N: ';
str = input(prompt,'s');
if isempty(str)
    str = 'Y';
end
if strcmp(str,'Y')
    for i = 2 : size(date, 2)
        date(:, i) = date(:, i) / max(date(:, i)); %Normalization
    end   
end

%%Selects random values from the file for test and train data
X = date; 
nrows = size(X, 1); %Number of rows 
randrows = randperm(nrows); %Random permutation
testdata = X(randrows(1:89), :); %Test data. 
traindata = X(randrows(90:end), :); %Train data

%%KNN Classifier function
d = zeros(size(traindata, 1), 1); %Distance
%Hits
hits1= 0; hits2=0; hits3=0;

for i = 1 : size(testdata)
    v = testdata(i,:);
    for j = 2 : size(traindata, 2)  
        % Find distance with all training data points
        d(:, 1) =  d(:, 1) + sqrt((traindata(:, j) - v(j)) .^ 2); %SUM sqrt(x-y)²
    end
    
    d(:, 2) = traindata(:, 1); %Classes
    d = sortrows(d, 1); %sorts the rows of d in ascending order.
    
    %Alloted the class which is at closest distance, mode
    classe(i) = mode(d(1 : K, 2)); 
    
    %STATISTICS
    %Hits class 1
    if(testdata(i,1)==1 & classe(i)==1) hits1= hits1+1; end
    %Hits class 2
    if(testdata(i,1)==2 & classe(i)==2) hits2= hits2+1; end
    %Hits class 3
    if(testdata(i,1)==3 & classe(i)==3) hits3= hits3+1; end

end

%Graphic
plot(classe, 'r.'); hold on; plot(testdata(:,1), 'o');
title('CLASS')
legend('Estimate with KNN','True classes');
ylim([0,4]);

%ERROR
    error = abs(classe' - testdata(:, 1));

%True positives
    TP = hits1+hits2+hits3; 
%False positives
    FP = length(classe) - TP; 
%True Negative
    %TN 
   
%SENSITIVITY
     Se = (hits1+hits2+hits3)/length(error)    %VP/VP+FN
%SPECIFICITY 
    Sp = (length(error) -(hits1+hits2+hits3))/length(error)    %VN/VN+FP 
    
fprintf('Sensitivity \t Specificity \t TP \t FP \n %f   \t     %f  \t %d \t %d \n', Se, Sp, TP, FP);






