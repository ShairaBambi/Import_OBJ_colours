-- Bambi's Importer
--22/11/2017
/** 
Copyright 2017 Shahnewaz Choudhury
*/

FBXFolderpath = maxfilepath
try ( destroyDialog bexporter) catch () -- closes the other exporter window if exporter is already open

rollout b_v_importer "Bambi's Vertex Importer" width:162 height:214
(
	label 'implabel' "Importer Options" pos:[42,7] width:78 height:13 align:#left -- Creates a label
 -- Creates a label
	label 'pathlabel' "Import Path" pos:[54,25] width:54 height:13 align:#left
	edittext 'userpathedit' "" pos:[13,52] width:136 height:17 align:#left -- creates an edit text box
 -- creates an edit text box
	button 'browsebut' "Browse for File" pos:[39,77] width:85 height:21 align:#left
	button 'Importbut' "Import OBJ" pos:[40,117] width:78 height:41 align:#left
	
		
	on browsebut pressed do
	(
		local string Fpath
		Fpath = getOpenFileName caption:"Please select file to import:"
		userpathedit.Text = FPath
	)
	on Importbut pressed do
	(
		this_file = openFile userpathedit.Text
		
		fn ADGetVertNum adline =
	(
	num = filterString adline "/"
	return num[1]
	)
	
	--vStore = #([0,0,0],[10,0,0],[0,10,0],[10,10,0])
	--fStore = #([1,2,3],[2,4,3])
	
	vStore = #()
	fStore = #()
	cStore = #() -- creates an array of undisclosed size this is for vertext colours
	test = #()
	
	-- Check if the file is actually there
	
	if this_file != undefined then
	(
	
	--Check if the file has any data
	while not(EOF this_file) do 
	
	(
	
	oneline = readLine this_file -- creates a variable
	a = filterString oneline " " -- Filters the space in the output
	
	case a[1] of 
	(
		--"v": format "[%, %, %]\n" a[2] a[3] a[4]
		"v": 
		(
			v = [(a[2] as float),(a[3] as float),(a[4] as float)]
			append vStore v
		)
	)
	
	case a[1] of
	(
		"v":
		(
		c = [(a[5] as float),(a[6] as float),(a[7] as float)]		
		append cStore (c as color)
			--append cstore ([30,30,90] as color)
		)
	)
	
	case a[1] of
	(
		"f":
		(
			f = [(ADGetVertNum a[2] as float),(ADGetVertNum a[3] as float),(ADGetVertNum a[4] as float)]
			append fStore f
		)
	)
	
	)
	
	-- Store the above values in an Array <vStore> and <fStore> then use mesh to output values.
	m = mesh vertices:vStore tverts: cStore faces:fStore --[ materialIDs:<array_of_integers> ] [ tverts:<array_of_point3s> ]
	
	
	getNumCPVVerts m
	setNumCPVVerts m m.numverts
	defaultVCFaces m
	for v=1 to getnumverts m do setVertColor m v cStore[v]
	update m 
	
	free this_file
	close this_file
	)
	)
)
createdialog  b_v_importer width:165 height:200 fgcolor:white