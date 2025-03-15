extends Node

var grid1D = []

func to2D(grid: Array) -> Array:
	var res = []
	
	for i in range(8):
		var row = []
		for j in range(8):
			row.append(grid[i * 8 + j])
		res.append(row)
	return res

func to1D(grid: Array) -> Array:
	var res = []
	
	for i in range(8):
		for j in range(8):
			res.append(grid[i][j])
	
	return res
