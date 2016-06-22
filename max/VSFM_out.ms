-- Max animated camera to NVM file.
-- TO DO: User interface
-- Align a dummy to camera, link it, select it than than export in NVM format
-- Doesn't work for target cameras.

-- Functions
fn cameracount = (
	camcount = 0
	for i in animationRange.start to animationRange.end do
	camcount = camcount +1
	return camcount as string
	)

fn fovToFocal infov = (
	camAp = getRendApertureWidth()
	fovTomm = (0.5*camap) / tan(0.5*infov)
	return fovTomm
	)
	
camAp = getRendApertureWidth()
sel = $
camfov = sel.curFOV
Point name:"ROTcamRead" pos:sel.pos isSelected:off box:on
select $ROTcamRead
rotate $ sel.rotation
$.parent = sel

--Vars
--camAp = getRendApertureWidth()
mycam = $ROTcamRead
prefix =  "/leArc1_imgs/le_Arc_" 
fileext = ".jpg"
frnm = 0-1
pxfl = renderWidth * ((fovToFocal camfov)as float/camAp)
cmnum = cameracount()

-- File stuff
out_name = ((GetDir #export)+"/SFM.txt")
out_file = createfile out_name

--File header

format "NVM_V3 \n" to:out_file
format "% \n" cmnum to:out_file

for myrange in animationRange.start to animationRange.end do
	at time myrange (
		frnm = frnm + 1;
		camfov = sel.curFOV;
		pxfl = renderWidth * ((fovToFocal camfov)as float/camAp);
		format "%%%\t% % % % % % % % %\n" prefix (formattedPrint frnm format:"04d") fileext pxfl ((mycam.rotation.x) as string) ((mycam.rotation.w*1) as string) ((mycam.rotation.z*1) as string) ((mycam.rotation.y*-1) as string) ((mycam.pos.x) as string) ((mycam.pos.y) as string) ((mycam.pos.z) as string)"0 0 " to:out_file)
		
format "\n0\n\n\n\n0\n\n\n\n0"  to:out_file
		
		
delete $ROTcamRead
close out_file
edit out_name