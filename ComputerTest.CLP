;;Fuzzy Set definition
(deftemplate BootTime
	0 11 minutes
	( (Fine (0 1) (3.5 0))
	  (Slow (3 0) (5 1) (7 0))
	  (ESlow (6 0) (8 1) (10 0))
	  (FBoot (9 0) (10 1))))

(deftemplate IdleCPU
	0 100 usage
	( (Fine (0 1) (40 0))
	  (NFine (20 0)(50 1) (80 0))
	  (Pedged (50 0) (100 1))))

(deftemplate IdleHDisk
	0 100 usage
	( (Fine (10 1) (40 0))
	  (Taken (30 0) (50 1) (75 0))
	  (Pedged (70 0) (90 1))))

(deftemplate Act
	0 14 action
	( (NWrong (1 1) (3 0))
	  (Startup (1 0) (3 1) (5 0))
	  (Start+Virus (3 0) (5 1) (7 0))
	  (Virus (5 0) (7 1) (9 0))
	  (Virus+Harddisk (7 0) (9 1) (11 0))
	  (Harddisk (9 0) (11 1) (13 0))
	  (Impossible (11 0) (13 1))))
;;startup question
(defrule start
	?i <- (initial-fact)
	=>
	(printout t "General Computer Diagnostics" crlf "Does the computer power on? (Y/N)" crlf)
	(assert (turnon (read)))
	(retract ?i))

;;No Turn On
(defrule Power
	?i <- (turnon N)
	=>
	(printout t "Check the power supply" crlf "Is the power supply faulty? (Y/N)" crlf)
	(assert (power (read)))
	(retract ?i))

;;power not faulty
(defrule NPower
	?i <- (power N)
	=>
	(printout t "See a specialist" crlf)
	(retract ?i))

;;power supply faulty
(defrule FPower
	?i <- (power Y)
	=>
	(printout t "Replace the power supply" crlf "Does the computer turn on now? (Y/N)" crlf)
	(assert (faulty (read)))
	(retract ?i))

;;computer turns on now
(defrule YFPower
	?i <- (faulty Y)
	=>
	(assert (turnon Y))
	(retract ?i))

;;computer did not turn on
(defrule NFPower
	?i <- (faulty N)
	=>
	(printout t "See a specialist" crlf)
	(assert (Done Y))
	(retract ?i))
	

;;get crisp inputs
(defrule Get_Inputs
	?i <- (turnon Y)
	=>
	(printout t "Enter Boot Time (0-10, 0 = 0 min, 10 = 10+ min/Not at all): " crlf)
	(bind ?response (read))
	(assert (crispBootTime ?response))
	(printout t "Enter CPU usage in idle (0-10, 0 = 0% & 10 = 100%/did not boot): " crlf)
	(bind ?response (read))
	(assert (crispIdleCPU ?response))
	(printout t "Enter Hard Disk usage in idle (0-100, 0 = 0% & 100 = 100%/did not boot): " crlf)
	(bind ?response (read))
	(assert (crispIdleHDisk ?response))
	(retract ?i))


;;fuzzify the inputs
(defrule fuzzify
	(crispBootTime ?b)
	(crispIdleCPU ?c)
	(crispIdleHDisk ?h)
	=>
	(assert (BootTime (?b 0) (?b 1) (?b 0)))
	(assert (IdleCPU (?c 0) (?c 1) (?c 0)))
	(assert (IdleHDisk (?h 0) (?h 1) (?h 0)))
)

;;defuzzify the outputs
(defrule defuzzify1
 	(declare (salience -1))
 	?f <- (Act ?)
 	=>
 	(bind ?t (moment-defuzzify ?f))
	(assert (Action ?t))
	(retract ?f))

;; FAM rule definition
(defrule FFF
	(BootTime Fine)
	(IdleCPU Fine)
	(IdleHDisk Fine)
	=>
	(assert (Act NWrong)))

(defrule SFF
	(BootTime Slow)
	(IdleCPU Fine)
	(IdleHDisk Fine)
	=>
	(assert (Act Startup)))

(defrule ESFF
	(BootTime ESlow)
	(IdleCPU Fine)
	(IdleHDisk Fine)
	=>
	(assert (Act Start+Virus)))

(defrule FBFF
	(BootTime FBoot)
	(IdleCPU Fine)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))

(defrule FNFF
	(BootTime Fine)
	(IdleCPU NFine)
	(IdleHDisk Fine)
	=>
	(assert (Act Virus)))

(defrule SNFF
	(BootTime Slow)
	(IdleCPU NFine)
	(IdleHDisk Fine)
	=>
	(assert (Act Start+Virus)))

(defrule ESNFF
	(BootTime ESlow)
	(IdleCPU NFine)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))

(defrule FBNFF
	(BootTime FBoot)
	(IdleCPU NFine)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))

(defrule FPF
	(BootTime Fine)
	(IdleCPU Pedged)
	(IdleHDisk Fine)
	=>
	(assert (Act Virus)))

(defrule SPF
	(BootTime Slow)
	(IdleCPU Pedged)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))

(defrule ESPF
	(BootTime ESlow)
	(IdleCPU Pedged)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))


(defrule FBPF
	(BootTime FBoot)
	(IdleCPU Pedged)
	(IdleHDisk Fine)
	=>
	(assert (Act Harddisk)))


(defrule FFT
	(BootTime Fine)
	(IdleCPU Fine)
	(IdleHDisk Taken)
	=>
	(assert (Act Virus)))

(defrule SFT
	(BootTime Slow)
	(IdleCPU Fine)
	(IdleHDisk Taken)
	=>
	(assert (Act Start+Virus)))

(defrule ESFT
	(BootTime ESlow)
	(IdleCPU Fine)
	(IdleHDisk Taken)
	=>
	(assert (Act Virus+Harddisk)))

(defrule FBFT
	(BootTime FBoot)
	(IdleCPU Fine)
	(IdleHDisk Taken)
	=>
	(assert (Act Harddisk)))

(defrule FNFT
	(BootTime Fine)
	(IdleCPU NFine)
	(IdleHDisk Taken)
	=>
	(assert (Act Virus)))

(defrule SNFT
	(BootTime Slow)
	(IdleCPU NFine)
	(IdleHDisk Taken)
	=>
	(assert (Act Start+Virus)))

(defrule ESNFT
	(BootTime ESlow)
	(IdleCPU NFine)
	(IdleHDisk Taken)
	=>
	(assert (Act Virus+Harddisk)))

(defrule FBNFT
	(BootTime FBoot)
	(IdleCPU NFine)
	(IdleHDisk Taken)
	=>
	(assert (Act Harddisk)))

(defrule FPT
	(BootTime Fine)
	(IdleCPU Pedged)
	(IdleHDisk Taken)
	=>
	(assert (Act Virus)))

(defrule SPT
	(BootTime Slow)
	(IdleCPU Pedged)
	(IdleHDisk Taken)
	=>
	(assert (Act Start+Virus)))

(defrule ESPT
	(BootTime ESlow)
	(IdleCPU Pedged)
	(IdleHDisk Taken)
	=>
	(assert (Act Harddisk)))

(defrule FBPT
	(BootTime FBoot)
	(IdleCPU Pedged)
	(IdleHDisk Taken)
	=>
	(assert (Act Harddisk)))

(defrule FFP
	(BootTime Fine)
	(IdleCPU Fine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Impossible)))

(defrule FNFP
	(BootTime Fine)
	(IdleCPU NFine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Impossible)))

(defrule FPP
	(BootTime Fine)
	(IdleCPU Pedged)
	(IdleHDisk Pedged)
	=>
	(assert (Act Impossible)))


(defrule SFP
	(BootTime Slow)
	(IdleCPU Fine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Virus+Harddisk)))

(defrule SNFP
	(BootTime Slow)
	(IdleCPU NFine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Virus+Harddisk)))

(defrule SPP
	(BootTime Slow)
	(IdleCPU Pedged)
	(IdleHDisk Pedged)
	=>
	(assert (Act Virus+Harddisk)))

(defrule ESFP
	(BootTime ESlow)
	(IdleCPU Fine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

(defrule ESNFP
	(BootTime ESlow)
	(IdleCPU NFine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

(defrule ESPP
	(BootTime ESlow)
	(IdleCPU Pedged)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

(defrule FBFP
	(BootTime FBoot)
	(IdleCPU Fine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

(defrule FBNFP
	(BootTime FBoot)
	(IdleCPU NFine)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

(defrule FBPP
	(BootTime FBoot)
	(IdleCPU Pedged)
	(IdleHDisk Pedged)
	=>
	(assert (Act Harddisk)))

;;using the defuzzified output
(defrule NothingWrong
	(declare (salience -2))
	?i <- (Action ?a)
	(test(< ?a 2))
	=>
	(printout t "There should be nothing wrong with your computer." crlf)
	(retract ?i))

(defrule StartupA
	?i <- (Action ?a)
	(test(>= ?a 2))
	(test(< ?a 4))
	=>
	(assert (StartP))
	(retract ?i))
	
(defrule StartupB
	(declare (salience -2))
	?i <- (StartP)
	=>
	(printout t "You might have to many startup programs." crlf)
	(printout t "Are there any Startup Programs you can turn off? (Y/N)" crlf)
	(assert (SProg (read)))
	(retract ?i))

(defrule StartupN
	?i <- (SProg N)
	=>
	(printout t "This problem must go deeper then." crlf)
	(assert (HardD))
	(retract ?i))
	
(defrule StartupY
	?i <- (SProg Y)
	=>
	(printout t "Are you able to turn them off? (Y/N)" crlf)
	(assert (SProgOff (read)))
	(retract ?i))
	
(defrule SprogOffN
	?i <- (SProgOff N)
	=>
	(printout t "This is another issue." crlf)
	(assert (Virus))
	(retract ?i))
	
(defrule SprogOffY
	?i <- (SProgOff Y)
	=>
	(printout t "Restart the computer." crlf)
	(printout t "Did it boot faster? (Y/N)" crlf)
	(assert (SProgCom (read)))
	(retract ?i))
	
(defrule SprogComY
	?i <- (SProgCom Y)
	=>
	(printout t "Do they Startup Programs turn themselves back on? (Y/N)" crlf)
	(assert (SProgTurn (read)))
	(retract ?i))
	
(defrule SprogComN
	?i <- (SProgCom N)
	=>
	(printout t "This must be another issue." crlf)
	(assert (Virus))
	(retract ?i))
	
(defrule SprogTurnY
	?i <- (SProgTurn Y)
	=>
	(printout t "This is another issue" crlf)
	(assert (Virus))
	(retract ?i))
	
(defrule SprogTurnN
	?i <- (SProgTurn N)
	=>
	(printout t "If there is no following message your computer should be fine." crlf)
	(retract ?i))
	
(defrule VirsusA
	?i <- (Action ?a)
	(test(>= ?a 6))
	(test(< ?a 8))
	=>
	(assert (Virus))
	(retract ?i))
	
(defrule VirusTest
	(declare (salience -3))
	?i <- (Virus)
	=>
	(printout t "You might have a virus or spyware installed." crlf)
	(printout t "Run a techshop approved virus scanner." crlf)
	(printout t "Did it find the virus? (Y/N)" crlf)
	(assert (VFind (read)))
	(retract ?i))
	
(defrule VirusTestN
	?i <- (VFind N)
	=>
	(printout t "Wipe the Harddrive and reinstall the OS" crlf)
	(retract ?i))
	
(defrule VirusTestY
	?i <- (VFind Y)
	=>
	(printout t "Delete the Virus" crlf)
	(printout t "Did it come Back? (Y/N)" crlf)
	(assert (VBack (read)))
	(retract ?i))

(defrule VBackY
	?i <- (VBack Y)
	=>
	(printout t "Wipe the Harddrive and reinstall the OS" crlf)
	(retract ?i))
	
(defrule VBackN
	?i <- (VBack N)
	=>
	(printout t "Your computer should be fine now." crlf)
	(retract ?i))
	
(defrule VirsusAndStart
	?i <- (Action ?a)
	(test(>= ?a 4))
	(test(< ?a 6))
	=>
	(assert (StartP))
	(assert (Virus))
	(retract ?i))
	
(defrule HDiskA
	?i <- (Action ?a)
	(test(>= ?a 10))
	(test(< ?a 12))
	=>
	(assert (HardD))
	(retract ?i))
	
(defrule HDiskB
	(declare (salience -2))
	?i <- (HardD)
	=>
	(printout t "You might have a Hardware or Software issue." crlf)
	(printout t "Run a Hardware Diagnostics." crlf)
	(printout t "Does it say that there is something wrong with your Hardware? (Y/N)" crlf)
	(assert (HIssue (read)))
	(retract ?i))
	
(defrule HDiskTestY
	?i <- (HIssue Y)
	=>
	(printout t "Replace part mentioned." crlf)
	(printout t "Rerun diagnostics and keep replacing all parts mention until nothing is showing a error." crlf)
	(printout t "Then if nothing follows this message your computer should be fine." crlf)
	(retract ?i))
	
(defrule HDiskTestN
	?i <- (HIssue N)
	=>
	(printout t "The issue must be with the Software." crlf)
	(printout t "Find and unistall/reinstall any Corrupt programs." crlf)
	(printout t "Does the issue still persist? (Y/N)" crlf)
	(assert (SIssue (read)))
	(retract ?i))
	
(defrule SIssueN
	?i <- (SIssue N)
	=>
	(printout t "If nothing follows this message your computer should be fine." crlf)
	(retract ?i))
	
(defrule SIssueY
	?i <- (SIssue Y)
	=>
	(printout t "This must be another issue." crlf)
	(assert (Virus))
	(retract ?i))
	
(defrule HDiskAndVirus
	?i <- (Action ?a)
	(test(>= ?a 8))
	(test(< ?a 10))
	=>
	(assert (HardD))
	(assert (Virus))
	(retract ?i))
	
(defrule Imposs
	?i <- (Action ?a)
	(test(>= ?a 12))
	=>
	(printout t "These numbers do not match anything within our system. Bring this computer into a specialist." crlf)
	(retract ?i))