function in = point_in_convex_polygon(P, T)
% POINT_IN_CONVEX_POLYGON   fast point-in-polygon test
%
% Checks whether test points [T] (N×2) lie within the polygon 
% [P] (M×2), which is defined through its counter-clockwise sorted, 
% unique vertices. Returns [N×1] logical array [in], the elements of 
% which are true if the corresponding point in [T] lies inside the 
% polygon [P], and false otherwise.
%
% This implementation is very fast, because it is specialized for 
% very simple polygons. The number of vertices should also remain small 
% compared to the number of test points if the method is to stay 
% efficient in terms of RAM. Because of these specializations, it only 
% produces correct results for polygons [P] for which:
%   - all internal angles are less than 180°;
%   - none of the edges intersects with any of the other edges;
%   - the polygon contains no "holes".
%
% Points exactly on the edge or on one of the vertices are counted as
% "inside" the polyon, although they may get excluded because of roundoff 
% error.
%   
% See also inpolygon.


% Please report bugs and inquiries to:
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com    (personal)
%              oldenhuis@luxspace.lu  (professional)
% Affiliation: LuxSpace sàrl
% Licence    : BSD


% If you find this work useful, please consider a donation:
% ahttps://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6G3S5UYM7HJ3N

    % Basic assertions
    assert(isnumeric(P) && size(P,2)==2 && size(P,1)>=3 && all(isfinite(P(:))) && all(isreal(P(:))),...
        'point_in_convex_polygon:PolyArgError',...
        'Polygon ''%s'' must be an N×2 numeric array with N > 2 and containing real, finite numbers.', inputname(1));
    assert(isnumeric(T) && size(T,2)==2 && all(isfinite(T(:))) && all(isreal(T(:))),...
        'point_in_convex_polygon:PointsArgError',...
        'Test points ''%s'' must be given as M×2 numeric array containing real, finite numbers.', inputname(2));

    % Compute difference vectors    
    dP = [P(2:end,:); P(1,:)] - P;    
    
    % Bounding box test
    in = all(bsxfun(@lt,T,max(P)) & bsxfun(@gt,T,min(P)),2);
    
    % Do full test only for the remaining points. 
    % The general condition for inclusion is:
    %             
    %    (P(i+1)-P(i)) × (T-P(i)) · [0 0 1]  >=  0
    %
    % where P is the array of polygon vertices, and T are the
    % points to test.
    in(in) = all(...
        bsxfun(@times, bsxfun(@minus,T(in,2),P(:,2).'), dP(:,1).') - ...
        bsxfun(@times, bsxfun(@minus,T(in,1),P(:,1).'), dP(:,2).') >= 0, 2);
    
end
