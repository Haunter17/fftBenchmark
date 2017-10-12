function F = getFFT2filter(size_row, size_col, i, j, isReal)

F = zeros(size_row, size_col);
for m = 1 : size_row
	for n = 1 : size_col
		if isReal
			F(m, n) = 1. / sqrt(size_row * size_col) * cos(2 * pi * (i * (m - 1) / size_row + j * (n - 1) / size_col));
		else
			F(m, n) = 1. / sqrt(size_row * size_col) * sin(2 * pi * (i * (m - 1) / size_row + j * (n - 1) / size_col));
		end
	end
end
end
