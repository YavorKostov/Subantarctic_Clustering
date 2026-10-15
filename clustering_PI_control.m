clear all

load model_domain.mat
load local_domain.mat
load April_PI_Climatology_Clustering.mat;

%%

FileNameSave='PI_control_clustering';

ListFiles=dir('E:\cs495o\thetao_so\*cs495*grid-T.nc');
FilePath='E:\cs495o\thetao_so\';

numClusters=7;
MemoryLength=20;


YearStart=201;
YearEnd=400;

Cinits=zeros(numClusters,4,MemoryLength);
C2inits=zeros(numClusters,4,MemoryLength);
IDXinits=zeros(numClusters,4,MemoryLength);

for iii=1:MemoryLength
    Cinits(:,:,iii)=C;
    C2inits(:,:,iii)=C2;
end

Cinit=nanmean(Cinits,3);
C2init=nanmean(C2inits,3);

C=Cinit;
C2=C2init;
C_sorted=sortrows(Cinit);

clear Cs C2s IDXs


area3=repmat(area,[1 1 length(gdept_1d)]);

volumeGrid=e3t_0.*area3;

volumeGrid=volumeGrid(~isnan(maskNaNs));

length_time=length([(YearStart-1)*12+4:12:YearEnd*12]);

LatArray_clustered=cell(numClusters, length_time);
LonArray_clustered=cell(numClusters, length_time);
gdept_0_clustered=cell(numClusters, length_time);
IDXs=cell(length_time,1);
Cs=cell(length_time,1);
C2s=cell(length_time,1);


ab={ListFiles.name};


iiiinnn=1;
for iiiin=(YearStart-1)*12+4:12:YearEnd*12 %length(ab)%
    abcd=ab{iiiin};

    FileName=strcat(FilePath,abcd);
    thetao =double(ncread(FileName,'thetao'));
    so = double(ncread(FileName,'so'));

    run clustering_script

    iiiinnn=iiiinnn+1;
end

save (strcat(FileNameSave,'_',num2str(YearStart),'_', num2str(YearEnd), '.mat'), 'LatArray_clustered', 'LonArray_clustered', 'gdept_0_clustered', 'Volume_clustered', 'IDXs', 'Cinit', 'Cs', 'numClusters', 'C2init', 'C2s', 'lat_3d', 'lon_3d', 'gdept_0', 'maskNaNs', 'SigmaThetaMeans','Sigma2Means','Sigma4Means','Sigma2Means', 'PVlocMeans', 'SaltMeans', 'ThetaMeans', 'Sigma2Stds', 'Sigma4Stds', 'SigmaThetaStds','PVlocStds', 'SaltStds', 'ThetaStds', '-v7.3')