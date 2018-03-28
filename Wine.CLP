;;startup question
(defrule start
	?i <- (initial-fact)
	=>
	(printout t "Vine Pairing Application" crlf "Is Your food a Meat? (Y/N)" crlf)
	(assert (meat (read)))
	(retract ?i))
	
;;No Meat
(defrule MeatN
	?i <- (meat N)
	=>
	(printout t "Is your food a Veggie? (Y/N)" crlf)
	(assert (veggie (read)))
	(retract ?i))
	
;;No Veggie
(defrule VeggieN
	?i <- (veggie N)
	=>
	(printout t "Is your food a Cheese? (Y/N)" crlf)
	(assert (cheese(read)))
	(retract ?i))
	
;;No Cheese
(defrule CheeseN
	?i <- (cheese N)
	=>
	(printout t "Is your food a Dessert? (Y/N)" crlf)
	(assert (dessert(read)))
	(retract ?i))
	
;;No Dessert
(defrule DessertN
	?i <- (dessert N)
	=>
	(printout t "Your food must be a Carb" crlf "Use Any Wine but a Big Red one."crlf)
	(retract ?i))
	
;;Yes Dessert
(defrule DessertY
	?i <- (dessert Y)
	=>
	(printout t "Use either Sweet White Wine or Dessert Wine."crlf)
	(retract ?i))
	
;;Yes Cheese
(defrule CheeseY
	?i <- (cheese Y)
	=>
	(printout t "Is your cheese a Hard Cheese? (Y/N)"crlf)
	(assert (cheeseH(read)))
	(retract ?i))
	
;;No Hard Cheese
(defrule HardCheeseN
	?i <- (cheeseH N)
	=>
	(printout t "Your food must be a Soft Cheese" crlf "Use Sweet White Wine, Sparkling Wine, or Dessert Wine."crlf)
	(retract ?i))

;;Yes Hard Cheese
(defrule HardCheeseY
	?i <- (cheeseH Y)
	=>
	(printout t "Use Sparkling Wine, Medium Red Wine, or Big Red Wine."crlf)
	(retract ?i))
	
;;Yes Veggie
(defrule VeggieY
	?i <- (veggie Y)
	=>
	(printout t "Is your food a Green Veggie? (Y/N)" crlf)
	(assert (green(read)))
	(retract ?i))
	
;;No Green
(defrule GreenN
	?i <- (green N)
	=>
		(printout t "Your food must be Roasted Veggies" crlf "Use Light Dry White Wine, Light Red Wine, or Rich White Wine."crlf)
	(retract ?i))
	
;;Yes Green
(defrule GreenY
	?i <- (green Y)
	=>
		(printout t "Use Light Dry White Wine or Sparkling Wine."crlf)
	(retract ?i))
	
;;Yes Meat
(defrule MeatY
	?i <- (meat Y)
	=>
	(printout t "Is your food a fish? (Y/N)" crlf)
	(assert (fish (read)))
	(retract ?i))
	
;;Yes Fish
(defrule FishY
	?i <- (fish Y)
	=>
	(printout t "Is your fish rich? (Y/N)" crlf)
	(assert (fishR (read)))
	(retract ?i))
	
;;Yes FishR
(defrule FishRY
	?i <- (fishR Y)
	=>
	(printout t "Use Rich White Wine or Light Red Wine." crlf)
	(retract ?i))
	
;;No FishR
(defrule FishRN
	?i <- (fishR N)
	=>
	(printout t "Use Light Dry White Wine or Sparkling Wine." crlf)
	(retract ?i))
	
;;NoFish
(defrule MeatM
	?i <- (fish N)
	=>
	(printout t "Is your meat cured or smoked? (Y/N)" crlf)
	(assert (smoke (read)))
	(retract ?i))
	
;;Yes Smoked
(defrule SmokedY
	?i <- (smoke Y)
	=>
	(printout t "Use Sweet White Wine, Medium Red Wine, Big Red Wine, or Dessert Wine." crlf)
	(retract ?i))
	
;;No Smoked
(defrule SmokedN
	?i <- (smoke N)
	=>
	(printout t "Is Your Meat Red? (Y/N)" crlf)
	(assert (red (read)))
	(retract ?i))
	
;;No Red
(defrule RedN
	?i <- (red N)
	=>
	(printout t "Use Rich White, Light Red Wine or Medium Red Wine" crlf)
	(retract ?i))
	
;;Yes Red
(defrule RedY
	?i <- (red Y)
	=>
	(printout t "Use Medium Red Wine or Big Red Wine" crlf)
	(retract ?i))
	
