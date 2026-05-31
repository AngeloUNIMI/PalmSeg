function [P, hostimage]=readasf(filename)
%
% function [P,hostimage]=readasf( filename )
%
% Reads an asf file into a point matrix P.
%
% $Id: readasf.m,v 1.1.1.1 2003/01/03 19:18:51 aam Exp $ 
%
if isempty( filename )
	error('An input file must be specified')
	return;	
end

hostimage = [];

if 0 
	fid = fopen( filename, 'rt' );
	[a,count] = fscanf( fid, '%s', 1 );
	xp=a;
	yp=count;
	fclose( fid );
end 

tmp_lines = textread(filename,'%s','delimiter','\n','whitespace','','commentstyle','shell');
lc = 1;
dc = 1;
nbpoints =0;
for i=1:length(tmp_lines)
	linelen = length( tmp_lines{i} );
	if linelen  > 0 
		str = tmp_lines{i};
		
		% read number of points
		if (lc==1)
			nbpoints = str2num( str );
		end
		
		% read point data
		if (lc>1 & lc<=nbpoints+1)			
			P(dc,:) = sscanf( str, '%f', 7 )';
			dc = dc+1;
		end		
		
		% read the hostimage
		if (lc==nbpoints+2)
			hostimage = str;
		end
		lc = lc+1; 
	end
end

	
