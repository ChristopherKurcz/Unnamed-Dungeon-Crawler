extends Spatial

var numBannerChildren
var numDecor
var chosenBannerNums = []

func _ready():
	randomize()
	numBannerChildren = get_child_count()
	numDecor = 0
	if randi()%2 == 0:
		numDecor+=1
	if randi()%3 == 0:
		numDecor+=1
	if randi()%5 == 0:
		numDecor+=1
	if randi()%8 == 0:
		numDecor+=1
	if randi()%13 == 0:
		numDecor+=1
	if randi()%21 == 0:
		numDecor+=1
	if randi()%34 == 0:
		numDecor+=1
	
	for _x in range(numDecor):
		var chosenBanner = randi()%numBannerChildren
		if not chosenBanner in chosenBannerNums:
			chosenBannerNums.append(chosenBanner)
			get_child(chosenBanner).visible = true
			get_child(chosenBanner).frame = randi()%((get_child(chosenBanner).hframes*get_child(chosenBanner).vframes)-1)
