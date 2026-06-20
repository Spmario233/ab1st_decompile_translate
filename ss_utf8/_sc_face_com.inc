/********************************************************
*														*
*						顔グラ表示						*
*														*
*********************************************************/
#macro		@FACE(@CHA_NAME, @FACE_NO(0))
			$set_face(@CHA_NAME, @FACE_NO)

#property	$cha_face : int
#property	$face_no : int

#command	$set_face(str, int)

