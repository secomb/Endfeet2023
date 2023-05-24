% Kdiffusion.m
% TWS, August 2022
% K+ diffusion in a simplified geometry representing
% astrocyte endfeet surrounding a vessel
% Geometric parameters derived from Mathiisen et al., 2010
% Needs Partial Differential Equation Toolbox
%%%%%%%% model 1 or 2 %%%%%%%
imodel = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import the geometry generated by createSTL.m
model = createpde();
file = ['endfeet',num2str(imodel),'.stl'];
gm = importGeometry(model,file);
figure(1)
axis equal;
pdegplot(gm,'EdgeLabels','on')
axis([0 4 0 14 * imodel - 10]);

%Generate the mesh with small elements on edge 5 (4 for model 2)
generateMesh(model,'Hedge',{6 - imodel,0.01},'Hgrad',1.3); 
figure(2)
pdeplot(model)

% set up time-dependent diffusion problem 
k = 2400/1.6^2; % Effective diffusivity in um2/s

% general form of PDE: m ∂2u/∂t2 + d ∂u/∂t − ∇⋅(c ∇u) + a u = f
specifyCoefficients(model,'m',0,'d',1,'c',k,'a',0,'f',0);

applyBoundaryCondition(model,'neumann', 'Edge',1:8, 'g',0);
applyBoundaryCondition(model,'dirichlet', 'Edge',9 - imodel, 'u',12);
setInitialConditions(model,3);

if imodel == 1
    endfeet1     %get parameter values used in createSTL
    tmax = 0.05;     
else
    endfeet2
    tmax = 0.5;
end

%% Generate color contour plots
ntimes = 6;
dtime = tmax/(ntimes - 1);

results = solvepde(model,0:dtime:tmax); 

% fractional cleft area
fprintf('Fractional cleft area = %f\n', wcleft/((rv + wve)*theta*pi()));

ifig = 2;
% plot results
for i = 1:ntimes
  if i ~= 4 && i~= 5
      ifig = ifig+1;
      t = figure(ifig);
      pdeplot(model,'XYData',results.NodalSolution(:,i));
      %title({['Time = ' num2str(results.SolutionTimes(i)) 's']})
      clim([3 12]);
      colormap('parula');
      axis off;
      axis equal;
      file = ['Figure',num2str(ifig),'_',num2str(imodel),'.gif'];
      exportgraphics(t,file,'Resolution','300') 
  end
end

%% time-dependent variation of wall concentration
ntimes = 31;
dtime = tmax/(ntimes - 1);

results = solvepde(model,0:dtime:tmax); 

% define sampling points on vessel wall
ntheta = 11;
tt = pi() * linspace(0,theta,ntheta);
x = (rv + wve/2) * sin(tt);
y = (rv + wve/2) * cos(tt);
Kwall = zeros(ntheta,ntimes);
Kwalla = zeros(1,ntimes);

for i = 1:ntimes % find concentrations on vessel wall
  Kwall = interpolateSolution(results,x,y,i);
  Kwalla(i) = mean(Kwall);
end
figure(ifig+1);
time = linspace(0, tmax, ntimes);
plot(time,Kwalla);


% Data needed for plots - parameters specified in createSTL.m

%Varying intercellular cleft width
% Kwalla100ic = Kwalla; %Intercellular cleft is 100 nm (0.050 in the program)
% Kwalla40ic = Kwalla;  %Intercellular cleft is 40 nm (0.020 in the program)
% Kwalla20ic = Kwalla; %Intercellular cleft is 20 nm (0.010 in the program, normal width)
% Kwalla10ic = Kwalla; %Intercellular cleft is 10 nm (0.005 in the program)
% Kwalla06ic = Kwalla; %Intercellular cleft is 6.67 nm (0.0033333 in program, 1/3)

%Varying distance between capillary and astrocytic endfeet while holding
% Kwalla500pc = Kwalla; %Distance is 500 nm (0.5 in program)
% Kwalla200pc = Kwalla; %Distance is 200 nm (0.2 in program)
% Kwalla100pc = Kwalla; %Distance is 100 nm (0.1 in program, normal width)
% Kwalla50pc = Kwalla; %Distance is 50 nm (0.05 in program)
% Kwalla20pc = Kwalla; %Distance is 20 nm (0.02 in program)
