extends Node

var grid1D = []
var direction := {
	'NO' = [-1, -1],
	'N' = [0, -1],
	'NE' =	[1, -1],
	'O' = [-1, 0],
	'E' = [1, 0],
	'SO' = [-1, 1],
	'S' = [0, 1],
	'SE' =[1, 1]
}

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

func TowerDeplacment(position : Array, grid : Array ) -> Array:
	var res = []
	return []
