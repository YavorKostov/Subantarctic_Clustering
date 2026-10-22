%% 

function [InputFieldOrdered]=reorder_fun(SigmaThetaLoc,PVlocMeans,InputField)

% It is not necessary to relabel the clusters for the PI climatology or the
% PI control simulation. However, under some of the ramp-up and ramp-down
% scenarios, the automatic ordering of the clusters is not always
% consistent. In that case, it is necessary to use the following code to
% 'manually' reorder the clusters by potential density. The STW cluster is
% additionally defined as more stratified than SAMW (higher |PV| magnitude) 
% and denser than Subtropical Mode Water.

% Example 
% (although this makes no difference for the PI Control cluster labels):
% load('PI_control_clustering_201_400.mat')
% SigmaThetaMeans_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,SigmaThetaMeans);
% Sigma2Means_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,Sigma2Means);
% Sigma4Means_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,Sigma4Means);
% SaltMeans_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,SaltMeans);
% ThetaMeans_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,ThetaMeans);
% Volume_clustered_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,Volume_clustered);
% PVlocMeans_reordered = reorder_fun(SigmaThetaMeans,PVlocMeans,PVlocMeans);

size_PVloc=size(PVlocMeans);

[B,I]=sort(SigmaThetaLoc,1);
for i=1:size_PVloc(1,2)
    Isel=I(:,i);
    PVlocSel=PVlocMeans(:,i);
    PVlocSorted(i,:)=PVlocSel(Isel);
end
PVlocSorted=(PVlocSorted');

InputFieldOrdered=PVlocMeans;
InputFieldOrdered(1:5,:)=PVlocSorted(1:5,:);
PVlocMeans=InputFieldOrdered;


[SigmaThetaLoc2]=reorder_fun0(SigmaThetaLoc,PVlocMeans,SigmaThetaLoc);
[InputField2]=reorder_fun0(SigmaThetaLoc,PVlocMeans,InputField);

SigmaThetaLocLoc1=SigmaThetaLoc2(1,:);
SigmaThetaLocLoc3=SigmaThetaLoc2(3,:);

InputFieldOrdered1a=InputField2(1,:);
InputFieldOrdered3a=InputField2(3,:);

InputFieldOrdered1=InputField2(1,:);
InputFieldOrdered3=InputField2(3,:);

InputFieldOrdered1(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1))=InputFieldOrdered3a(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1));
InputFieldOrdered3(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1))=InputFieldOrdered1a(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1));

InputFieldOrdered=InputField2;
InputFieldOrdered(1,:)=InputFieldOrdered1;
InputFieldOrdered(3,:)=InputFieldOrdered3;

end


function [InputFieldOrdered]=reorder_fun0(SigmaThetaLoc,PVlocMeans,InputField)

size_InputField=size(InputField);

[B,I]=sort(SigmaThetaLoc,1);
for i=1:size_InputField(1,2)
    Isel=I(:,i);
    InputFieldSel=InputField(:,i);
    InputFieldSorted(i,:)=InputFieldSel(Isel);
    SigmaThetaLocSorted(i,:)=SigmaThetaLoc(Isel);
end
InputFieldSorted=(InputFieldSorted');


InputFieldOrdered=InputField;
InputFieldOrdered(1:5,:)=InputFieldSorted(1:5,:);
SigmaThetaLocLoc=SigmaThetaLocSorted';

InputFieldOrdered1a=InputFieldOrdered(1,:);
InputFieldOrdered2a=InputFieldOrdered(2,:);

InputFieldOrdered1=InputFieldOrdered(1,:);
InputFieldOrdered2=InputFieldOrdered(2,:);
InputFieldOrdered3=InputFieldOrdered(3,:);

SigmaThetaLocLoc1=SigmaThetaLocLoc(1,:);
SigmaThetaLocLoc2=SigmaThetaLocLoc(2,:);
SigmaThetaLocLoc3=SigmaThetaLocLoc(3,:);
SigmaThetaLocLoc1a=SigmaThetaLocLoc(1,:);
SigmaThetaLocLoc2a=SigmaThetaLocLoc(2,:);
SigmaThetaLocLoc3a=SigmaThetaLocLoc(3,:);

InputFieldOrdered1(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)))=InputFieldOrdered2a(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)));
InputFieldOrdered2(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)))=InputFieldOrdered1a(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)));
PVlocMeans2=PVlocMeans(2,:); PVlocMeans1=PVlocMeans(1,:);
PVlocMeans2(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)))=PVlocMeans1(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)));
SigmaThetaLocLoc2(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)))=SigmaThetaLocLoc1a(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)));
SigmaThetaLocLoc1(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)))=SigmaThetaLocLoc2a(abs(PVlocMeans(1,:))>abs(PVlocMeans(2,:)));


InputFieldOrdered2a=InputFieldOrdered2;
SigmaThetaLocLoc2a=SigmaThetaLocLoc2;

InputFieldOrdered3a=InputFieldOrdered(3,:);
InputFieldOrdered2(abs(PVlocMeans2)<abs(PVlocMeans(3,:)))=InputFieldOrdered3a(abs(PVlocMeans2)<abs(PVlocMeans(3,:)));
InputFieldOrdered3(abs(PVlocMeans2)<abs(PVlocMeans(3,:)))=InputFieldOrdered2a(abs(PVlocMeans2)<abs(PVlocMeans(3,:)));
SigmaThetaLocLoc3(abs(PVlocMeans2)<abs(PVlocMeans(3,:)))=SigmaThetaLocLoc2a(abs(PVlocMeans2)<abs(PVlocMeans(3,:)));

InputFieldOrdered1a=InputFieldOrdered1;
InputFieldOrdered3a=InputFieldOrdered3;

InputFieldOrdered1(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1))=InputFieldOrdered3a(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1));
InputFieldOrdered3(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1))=InputFieldOrdered1a(abs(SigmaThetaLocLoc3)<abs(SigmaThetaLocLoc1));

InputFieldOrdered(1,:)=InputFieldOrdered1;
InputFieldOrdered(2,:)=InputFieldOrdered2;
InputFieldOrdered(3,:)=InputFieldOrdered3;
end