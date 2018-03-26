MotifDemo.m 							// demo for facade matching
cost = CalcMotifCost(street, aerial) 	// facade matching code. street, aerial are motifs. cost is 0 -> 1, 0 being best.
BuildGTMain.m							// Extracts motifs from lattice structures in a city. calls CalcMotifCost
prepare_for_lattice_detection.m			// Sets up directories with highres & blurred street-view images
perform_lattice_detection.m				// Performs lattice detection and manages directory saves
GTPathManager							// Where all directory information is located
UTMoffset2imcoords.m					// street coordinates to aerial pixel location
findSV2AerialMatches.m					// demo for UTMoffset2imcoords.m
imcoords2LL.m							// aerial pixel location to ESTIMATED street coordinates
CREATE_HULL_SPACE.m						// Reads data and generates visual