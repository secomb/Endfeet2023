% createSTL.m
% TWS, August 2022
% Program to create 2D geometry representing astrocyte endfeet
%%%%%%%% model 1 or 2 %%%%%%%
model = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file = ['endfeet',num2str(model),'.stl'];
fid = fopen(file,'wt');
fprintf(fid,'solid Endfeet\n');

theta = 1/2.5;    % in units of pi, based on 2.5 clefts per cross-section
% domain is 1/5 of circumference, contains half a cleft
% dimensions in um
rv = 2.5;
wcleft = 0.01;  % half a cleft width
wve = 0.1;  %must be an integer multiple of wcleft
lcleft = 0.2;   %must be an integer multiple of wcleft

if model == 1
    wspace = 1;  %must be an integer multiple of wcleft
    lspace = 1;   %must be an integer multiple of wcleft    
else
    wspace = 0.5;  %must be an integer multiple of wcleft
    lspace = 15;   %must be an integer multiple of wcleft 
end
dr = wcleft;
dtt = 0.01; % dtheta in units of pi
dt = dtt * pi();
dx = wcleft;
dy = wcleft;
eps = 1e-6; % needed to get correct number of steps

% space around vessel
for r = rv:dr:rv + wve - eps
    for tt = 1/2-theta:dtt:1/2-eps
      t = tt * pi();
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',wcleft+r*cos(t),r*sin(t),0);
      fprintf(fid,'vertex %f %f %f\n',wcleft+(r+dr)*cos(t),(r+dr)*sin(t),0);
      fprintf(fid,'vertex %f %f %f\n',wcleft+(r+dr)*cos(t+dt),(r+dr)*sin(t+dt),0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',wcleft+r*cos(t),r*sin(t),0);
      fprintf(fid,'vertex %f %f %f\n',wcleft+(r+dr)*cos(t+dt),(r+dr)*sin(t+dt),0);
      fprintf(fid,'vertex %f %f %f\n',wcleft+r*cos(t+dt),r*sin(t+dt),0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
    end
end
% cleft between endfeet
for x = 0:dx:wcleft - eps
    for y = rv:dy:rv + wve + lcleft - eps
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',x,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y+dy,0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',x,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y+dy,0);
      fprintf(fid,'vertex %f %f %f\n',x,y+dy,0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
    end
end
% extracellular space
for x = 0:dx:wspace - eps
    for y = rv + wve + lcleft:dy:rv + wve + lcleft + lspace - eps
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',x,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y+dy,0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
      fprintf(fid,'facet normal 0 0 1\n');
      fprintf(fid,'outer loop\n');
      fprintf(fid,'vertex %f %f %f\n',x,y,0);
      fprintf(fid,'vertex %f %f %f\n',x+dx,y+dy,0);
      fprintf(fid,'vertex %f %f %f\n',x,y+dy,0);
      fprintf(fid,'endloop\n');
      fprintf(fid,'endfacet\n');
    end
end
fprintf(fid,'endsolid Endfeet\n');
fclose(fid);

file = ['endfeet',num2str(model),'.m'];
fid = fopen(file,'wt');
fprintf(fid,'theta = %f;\n', theta);
fprintf(fid,'rv = %f;\n',rv);
fprintf(fid,'wcleft = %f;\n',wcleft);
fprintf(fid,'wve = %f;\n',wve);
fprintf(fid,'lcleft = %f;\n',lcleft);
fprintf(fid,'wspace = %f;\n',wspace);
fprintf(fid,'lspace = %f;\n',lspace);
fclose(fid);
