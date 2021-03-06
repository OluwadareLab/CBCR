%Increase structure Size
convert2xyz;

scale=100/max(max(xyz));
xyz=xyz*scale;
%output pdb file
pdb.X=xyz(:,1);
pdb.Y=xyz(:,2);
pdb.Z=xyz(:,3);
%data.outfile = ['../hic/output/', num2str(name),'.pdb']; %output directory.

pdb.outfile = [str_name,'.pdb']; %output directory.

if exist(pdb.outfile, 'file')==2   %delet file if exists.
  delete(pdb.outfile);
end

mat2pdb(pdb); % Converts the mat XYZ coordinates to PDB format.
