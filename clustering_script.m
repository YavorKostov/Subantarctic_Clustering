
so(so<=0)=NaN;
thetao(isnan(so) | so<=0)=NaN;


pressRefL1=0*so+1;
pressRefL=0*pressRefL1;
RC=gdept_1d;
for iiii=1:length(gdept_1d)
    pressRefL(:,:,iiii)=abs(gdept_1d(iiii));
end


pdep=pressRefL;
rC=gdept_1d;
Rho_down = nemo_eos3d_fun_insitu(so, thetao,pressRefL);


p2=pressRefL;
for j=2:length(gdept_1d)
    p2(:,:,j-1)=pressRefL(:,:,j);
end


Rho_up = nemo_eos3d_fun_insitu(so,thetao,p2);


PVloc=NaN*so;

fCori=2*7.2921*1e-5*sind(lat);

for k=2:length(gdept_1d)
    PVloc(:,:,k) =     fCori ...
        .*(1/(rC(k)-rC(k-1)))... %*(-1) ...
        .*((Rho_down(:,:,k)-Rho_up(:,:,k-1))./Rho_down(:,:,k))...
        /1.0E-12;
end


SigmaTheta = nemo_eos3d_fun_insitu(so,thetao,0);
Sigma1p5 = nemo_eos3d_fun_insitu(so,thetao,1500);
Sigma2 = nemo_eos3d_fun_insitu(so,thetao,2000);
Sigma4 = nemo_eos3d_fun_insitu(so,thetao,4000);

Sigma1p5_array=Sigma1p5(~isnan(maskNaNs));
SigmaTheta_array=SigmaTheta(~isnan(maskNaNs));
Sigma2_array=Sigma2(~isnan(maskNaNs));
Sigma4_array=Sigma4(~isnan(maskNaNs));

PVloc_array=PVloc(~isnan(maskNaNs));
Salt_array=so(~isnan(maskNaNs));
Theta_array=thetao(~isnan(maskNaNs));


PropArray=horzcat(Sigma4_array(:), PVloc_array(:), Salt_array(:), Theta_array(:));

[z,mu,sigma] = zscore(PropArray);

Mz = (C2-mu) ./ sigma;
[IDX, C, SUMD, D] = kmeans(z,[],'start', Mz, 'MaxIter',500);

sigma_r=repmat(sigma',[1 numClusters])';
mu_r=repmat(mu',[1 numClusters])';
C2=C.*sigma_r+mu_r;

IDXs{iiiinnn}=IDX;
Cs{iiiinnn}=C;
C2s{iiiinnn}=C2;

C2col1=C2(:,1);

[B,I] = sort(C2col1);




for ClusterSelRaw=1:numClusters

    ClusterSel=I(ClusterSelRaw);

    Sigma1p5_clustered=Sigma1p5_array(IDX==ClusterSelRaw);
    SigmaTheta_clustered=SigmaTheta_array(IDX==ClusterSelRaw);
    Sigma2_clustered=Sigma2_array(IDX==ClusterSelRaw);
    Sigma4_clustered=Sigma4_array(IDX==ClusterSelRaw);

    PVloc_clustered=PVloc_array(IDX==ClusterSelRaw);
    Salt_clustered=Salt_array(IDX==ClusterSelRaw);
    Theta_clustered=Theta_array(IDX==ClusterSelRaw);


    Volume_clustered(ClusterSel, iiiinnn)=nansum(volumeGrid(IDX==ClusterSelRaw));
    Volume_this_cluster=(volumeGrid(IDX==ClusterSelRaw));

    LatArray_clustered{ClusterSel, iiiinnn}=lat_3d(IDX==ClusterSelRaw);
    LonArray_clustered{ClusterSel, iiiinnn}=lon_3d(IDX==ClusterSelRaw);
    gdept_0_clustered{ClusterSel, iiiinnn}=gdept_0(IDX==ClusterSelRaw);


    SigmaThetaMins(ClusterSel, iiiinnn)=min(SigmaTheta_clustered(:));
    SigmaThetaMaxes(ClusterSel, iiiinnn)=max(SigmaTheta_clustered(:));
    PVlocMins(ClusterSel, iiiinnn)=min(PVloc_clustered(:));
    PVlocMaxes(ClusterSel, iiiinnn)=max(PVloc_clustered(:));
    SaltMins(ClusterSel, iiiinnn)=min(Salt_clustered(:));
    SaltMaxes(ClusterSel, iiiinnn)=max(Salt_clustered(:));
    ThetaMins(ClusterSel, iiiinnn)=min(Theta_clustered(:));
    ThetaMaxes(ClusterSel, iiiinnn)=max(Theta_clustered(:));

    Sigma1p5Means(ClusterSel, iiiinnn)=nansum(Sigma1p5_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));
    SigmaThetaMeans(ClusterSel, iiiinnn)=nansum(SigmaTheta_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));
    Sigma2Means(ClusterSel, iiiinnn)=nansum(Sigma2_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));
    Sigma4Means(ClusterSel, iiiinnn)=nansum(Sigma4_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));

    PVlocMeans(ClusterSel, iiiinnn)=nansum(PVloc_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));
    SaltMeans(ClusterSel, iiiinnn)=nansum(Salt_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));
    ThetaMeans(ClusterSel, iiiinnn)=nansum(Theta_clustered(:).*Volume_this_cluster(:))/nansum(Volume_this_cluster(:));

    SigmaThetaStds(ClusterSel, iiiinnn)=std(SigmaTheta_clustered(:));
    Sigma1p5Stds(ClusterSel, iiiinnn)=std(Sigma1p5_clustered(:));
    Sigma2Stds(ClusterSel, iiiinnn)=std(Sigma2_clustered(:));
    Sigma4Stds(ClusterSel, iiiinnn)=std(Sigma4_clustered(:));
    PVlocStds(ClusterSel, iiiinnn)=std(PVloc_clustered(:));
    SaltStds(ClusterSel, iiiinnn)=std(Salt_clustered(:));
    ThetaStds(ClusterSel, iiiinnn)=std(Theta_clustered(:));

end

if MemoryLength>1
    for iii=1:MemoryLength-1
        Cinits(:,:,iii)=Cinits(:,:,iii+1);
        C2inits(:,:,iii)=C2inits(:,:,iii+1);
    end
    Cinits(:,:,MemoryLength)=C;
    C2inits(:,:,MemoryLength)=C2;

    Cinit=nanmean(Cinits,3);
    C2init=nanmean(C2inits,3);

    C=Cinit;
    C2=C2init;
end