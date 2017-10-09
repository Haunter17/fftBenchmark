function [row_ind, col_ind] = convert2DIndex(index, num_row)
% given an index, convert it into index for 2D
col_ind = ceil(index / num_row);
row_ind = mod(index, num_row);
row_ind(find(row_ind == 0)) = num_row;
