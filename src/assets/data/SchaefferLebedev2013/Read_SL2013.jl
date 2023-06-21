# load in the Vs tomography of Schaeffer & Lebedev (2013)
# the file was downloaded from here: https://schaeffer.ca/tomography/sl2013sv/ (Version 0.5m (April 2013)), 
# which provides a gridded version of their model
# From their README:
# The perturbations (column 4) are in m/s from the reference model (column 5),
# also in m/s. Please see the note below about the reference model. The
# perturbations in percentage (column 6) are with respect to the 3D reference
# model also. Column 7 is the absolute velocity (dVs + VsRef) in m/s. Finally,
# Column 8 is the mean velocity computed for that depth, with Column 9 being
# the perturbation with respect to the mean.

using GMT, GeophysicalModelGenerator, GeoStats

# 1. load data, data format : ["Depth (km)   lon         lat      dVs (m/s)  VsRef (m/s)   dVs (%)   VsAbs (m/s)   VsMean (m/s)   dVsM (%)"]
data = gmtread("./SL2013sv_25k-0.5d.mod",table=true);
tmp  = data[1];

depth      = -1 .* tmp[1:end,1];
lon        = tmp[1:end,2];
lat        = tmp[1:end,3];``
dVs_km_s    = tmp[1:end,4];
Vs_ref     = tmp[1:end,5];
dVs_p      = tmp[1:end,6];
Vs         = tmp[1:end,7];
Vs_mean    = tmp[1:end,8];
dVsm       = tmp[1:end,9];

# 2. Select latitude and longitude range for the model
lat_min = 37.0
lat_max = 49.0
lon_min = 4.0
lon_max = 20.0

# Create 3D regular grid:
Depth_vec       =   unique(depth)
Lon,Lat,Depth   =   LonLatDepthGrid(lon_min:0.5:lon_max,lat_min:0.25:lat_max,Depth_vec);

# Employ GeoStats to interpolate irregular data points to a regular grid
dLon = Lon[2,1,1]-Lon[1,1,1]
dLat = Lat[1,2,1]-Lat[1,1,1]
Cgrid = CartesianGrid((size(Lon,1),size(Lon,2)),(minimum(Lon),minimum(Lat)),(dLon,dLat))
Vs_3D       = zeros(size(Depth));
dVs_km_s_3D = zeros(size(Depth));
dVs_p_3D    = zeros(size(Depth));
Vs_ref_3D   = zeros(size(Depth));


for iz=1:size(Depth,3)
    println("Depth = $(Depth[1,1,iz])")
    ind   = findall(x -> x==Depth[1,1,iz], depth)
    coord = PointSet([lon[ind]'; lat[ind]'])


    Geo   = georef((Vs=Vs[ind],dVs_km_s=dVs_km_s[ind],dVs_p=dVs_p[ind],Vs_ref=Vs_ref[ind]), coord)
    P     = EstimationProblem(Geo, Cgrid,(:Vs, :dVs_km_s, :dVs_p, :Vs_ref))
    S     = IDW(:Vs => (distance=Euclidean(),neighbors=2), :dVs_km_s => (distance=Euclidean(),neighbors=2), :dVs_p => (distance=Euclidean(),neighbors=2), :Vs_ref => (distance=Euclidean(),neighbors=2)); 
    sol   = solve(P, S)

    sol_Vs       = values(sol).Vs
    sol_dVs_km_s  = values(sol).dVs_km_s
    sol_dVs_p    = values(sol).dVs_p
    sol_Vs_ref   = values(sol).Vs_ref

    tmp = reshape(sol_Vs, size(domain(sol)));
    Vs_3D[:,:,iz] = tmp;
    tmp = reshape(sol_dVs_km_s, size(domain(sol)));
    dVs_km_s_3D[:,:,iz] = tmp;
    tmp = reshape(sol_dVs_p, size(domain(sol)));
    dVs_p_3D[:,:,iz] = tmp;
    tmp = reshape(sol_Vs_ref, size(domain(sol)));
    Vs_ref_3D[:,:,iz] = tmp;
end

# Save data to paraview:
Data_set    =   GeophysicalModelGenerator.GeoData(Lon,Lat,Depth,(Vs_km_s=Vs_3D,dVs_km_s=dVs_km_s_3D,dVs_p=dVs_p_3D))   # the GeoStats package defines its own GeoData structure, so you have to choose the correct one here
Write_Paraview(Data_set, "SL2013")