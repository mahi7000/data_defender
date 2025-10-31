extends Node

static func create_score_icon() -> Texture2D:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color("00FFFF"))
	return ImageTexture.create_from_image(image)

static func create_lives_icon() -> Texture2D:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color("FF0000"))
	return ImageTexture.create_from_image(image)

static func create_level_icon() -> Texture2D:
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color("00FF00"))
	return ImageTexture.create_from_image(image)
