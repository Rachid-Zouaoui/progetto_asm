asm LettoreMP3

import StandardLibrary

signature:

	// DOMAINS
	enum domain Stato = { OFF | ON | PLAY | PAUSE | SELECTION}
	enum domain Volume = { VOL1_MIN | VOL2 | VOL3 | VOL4 | VOL5_MAX}
	enum domain Operazione = { ACCENDI | SPEGNI | AVVIA | PAUSA | SCEGLI | PIU | MENO }

	// FUNCTIONS
	dynamic controlled stato : Stato
	dynamic controlled volume : Volume
	dynamic monitored operazione : Operazione

definitions:

	// RULE DEFINITIONS

	//lettore spento
	rule r_cambiaOFF =
		seq
			let ($r = operazione) in
				switch ($r)
					case ACCENDI:
						stato := ON
				endswitch
			endlet
			volume := VOL3
		endseq

	//lettore acceso
	rule r_cambiaON =
		let ($r = operazione) in
			switch ($r)
				case SPEGNI:
					stato := OFF
				case SCEGLI:
					stato := SELECTION
				case PIU:
					switch(volume)
						case VOL1_MIN:
							volume := VOL2
						case VOL2:
							volume := VOL3
						case VOL3:
							volume := VOL4
						case VOL4:
							volume := VOL5_MAX
						case VOL5_MAX:
							volume := VOL5_MAX
					endswitch
				case MENO:
					switch(volume)
						case VOL1_MIN:
							volume := VOL1_MIN
						case VOL2:
							volume := VOL1_MIN
						case VOL3:
							volume := VOL2
						case VOL4:
							volume := VOL3
						case VOL5_MAX:
							volume := VOL4
					endswitch
				endswitch
		endlet

	//lettore IN SELEZIONE
	rule r_cambiaSELECTION =
		let ($r = operazione) in
			switch ($r)
				case SPEGNI:
					stato := OFF
				case AVVIA:
					stato := PLAY
				case PIU:
					switch(volume)
						case VOL1_MIN:
							volume := VOL2
						case VOL2:
							volume := VOL3
						case VOL3:
							volume := VOL4
						case VOL4:
							volume := VOL5_MAX
						case VOL5_MAX:
							volume := VOL5_MAX
					endswitch
				case MENO:
					switch(volume)
						case VOL1_MIN:
							volume := VOL1_MIN
						case VOL2:
							volume := VOL1_MIN
						case VOL3:
							volume := VOL2
						case VOL4:
							volume := VOL3
						case VOL5_MAX:
							volume := VOL4
					endswitch
				endswitch
		endlet



	//lettore in riproduzione
	rule r_cambiaPLAY =
		let ($r = operazione) in
			switch ($r)
				case SPEGNI:
					stato := OFF
				case PAUSA:
					stato := PAUSE
				case SCEGLI:
					stato := SELECTION
				case PIU:
					switch(volume)
						case VOL1_MIN:
							volume := VOL2
						case VOL2:
							volume := VOL3
						case VOL3:
							volume := VOL4
						case VOL4:
							volume := VOL5_MAX
						case VOL5_MAX:
							volume := VOL5_MAX
					endswitch
				case MENO:
					switch(volume)
						case VOL1_MIN:
							volume := VOL1_MIN
						case VOL2:
							volume := VOL1_MIN
						case VOL3:
							volume := VOL2
						case VOL4:
							volume := VOL3
						case VOL5_MAX:
							volume := VOL4
					endswitch
				endswitch
		endlet

	//lettore in pausa
	rule r_cambiaPAUSE =
		let ($r = operazione) in
			switch ($r)
				case SPEGNI:
					stato := OFF
				case AVVIA:
					stato := PLAY
				case SCEGLI:
					stato := SELECTION
				case PIU:
					switch(volume)
						case VOL1_MIN:
							volume := VOL2
						case VOL2:
							volume := VOL3
						case VOL3:
							volume := VOL4
						case VOL4:
							volume := VOL5_MAX
						case VOL5_MAX:
							volume := VOL5_MAX
					endswitch
				case MENO:
					switch(volume)
						case VOL1_MIN:
							volume := VOL1_MIN
						case VOL2:
							volume := VOL1_MIN
						case VOL3:
							volume := VOL2
						case VOL4:
							volume := VOL3
						case VOL5_MAX:
							volume := VOL4
					endswitch
				endswitch
		endlet



	// INVARIANTS

	// MAIN RULE
	main rule r_Main =
		if (true) then
			if (stato = OFF) then
				r_cambiaOFF[]
			else
				if (stato = SELECTION) then
					r_cambiaSELECTION[]
				else
					if (stato = PAUSE) then
						r_cambiaPAUSE[]
					else
						if (stato = PLAY) then
							r_cambiaPLAY[]
						else
							r_cambiaON[]
						endif
					endif
				endif
			endif
		endif


// INITIAL STATE
default init s0:
	function stato = OFF
	function volume = VOL3
