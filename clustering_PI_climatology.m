clear all

load model_domain.mat
load local_domain.mat
load InitialGuesses_Climatology.mat M
load April_Climatology.mat

rng(0)
numClusters=7;
MemoryLength=1;
length_time=1;


area3=repmat(area,[1 1 length(gdept_1d)]);
volumeGrid=e3t_0.*area3;
volumeGrid=volumeGrid(~isnan(maskNaNs));
LatArray_clustered=cell(numClusters, length_time);
LonArray_clustered=cell(numClusters, length_time);
gdept_0_clustered=cell(numClusters, length_time);
IDXs=cell(length_time,1);
Cs=cell(length_time,1);
C2s=cell(length_time,1);


Sigma4_array=Sigma4_array(~isnan(maskNaNs));
PVloc_array=PVloc_array(~isnan(maskNaNs));
Salt_array=Salt_array(~isnan(maskNaNs));
Theta_array=Theta_array(~isnan(maskNaNs));


PropArray=horzcat(Sigma4_array(:), PVloc_array(:), Salt_array(:), Theta_array(:));
lat_3d=lat_3d(~isnan(maskNaNs));
lon_3d=lon_3d(~isnan(maskNaNs));
gdept_0=gdept_0(~isnan(maskNaNs));

[z,mu,sigma] = zscore(PropArray);

Mz = (M(:,1:4)-mu) ./ sigma;
[IDX, C, SUMD, D] = kmeans(z,[],'start', Mz, 'MaxIter', 500);

sigma_r=repmat(sigma',[1 numClusters])';
mu_r=repmat(mu',[1 numClusters])';
C2=C.*sigma_r+mu_r;

FileName2=strcat('April_PI_Climatology_Clustering.mat');
save(FileName2, 'IDX', 'C', 'SUMD', 'D', 'numClusters', 'mu', 'sigma', 'C2', 'lat_3d', 'lon_3d', 'gdept_0', 'maskNaNs', '-v7.3')




