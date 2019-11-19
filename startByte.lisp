(load "./Task1/Helper.lisp")
(load "./Task1/Display.lisp")
(load "./Task1/Validation.lisp")


(defun startGame ()
    (welcome)
    (readBoardDimension)
    (setq globalMatrix (matrixFactoryByte 1 1))
    (setq playerX 0)
    (setq playerO 0)
    (setq isX t)
    (setq isPerson 1) ;treba dodati da se izabere ko igra prvi
    (displayBoard)
    (play)
)

(defun play()
    (loop while (not (endOfGame)) 
    do (getMove))
)

(defun welcome ()
    (format t "~%. . . . . . . . . . . . . . . . . . . . . . .")
    (format t "~%. . . . . .    Welcome to BYTE    . . . . . .")
    (format t "~%. . . . . . . . . . . . . . . . . . . . . . .~%")
)

(defun readBoardDimension () 
    (format t "~%. . . . . . . . . . . . . . . . . . . . . . .")
    (format t "~%Enter board dimension: ")
    (setq dimension (read))
    (format t ". . . . . . . . . . . . . . . . . . . . . . .")
)

(defun matrixFactoryByte (row column)
    (cond ((= (1- dimension) row) '())
        ((and (= 1 (mod row 2)) (< column (+ 1 dimension)) ) (cons (cons (list row column) (list '(X))) (matrixFactoryByte row (+ 2 column))  ) )
        ((= (+ 1 dimension) column) (matrixFactoryByte (1+ row) '0))
        ((and (= 0 (mod row 2)) (< column dimension)) (cons (cons (list row column) (list '(O)) ) (matrixFactoryByte row (+ 2 column)) ) )
        ((= dimension column) (matrixFactoryByte (1+ row) '1 ) )
    )
)

(defun playMove (move matrix)
    (setq globalMatrix ;;Cuvamo matricu kao globalnu promenljivu da bi mogli da je stampamo
        (progn 
            (cond
                ((null matrix) '())
                ((and 
                    (not (equalp (caar matrix) (list from (1- (cadar move))) )) ;; Ako nije jedno od polja koja su prosledjena u "move"..
                    (not (equalp (caar matrix) (list to (1- (cadadr move))) ))
                )
                (cons (car matrix) (playMove move (cdr matrix))) ;;Onda idemo dalje, cuvamo prethodne elemente..
                )
                (t 
                    (if (equalp (caar matrix) (list to (1- (cadadr move)))) ;;E sad, ako je ono polje u koje pomeramo element(plocicu)
                        (cons
                            (list
                                (caar matrix)
                                (append 
                                    elTo ;;spajamo elemenat koji smo uzeli iz polja sa kog saljemo
                                    (cadar matrix) ;;i ostatak liste
                                )
                            )
                            (playMove move (cdr matrix))
                        ) ;; A ako je polje iz kog saljemo taj elemenat, samo ga brisemo
                        (cons
                            (list
                                (caar matrix)
                                (getRestOfList elTo (cadar matrix))
                            )
                            (playMove move (cdr matrix))
                        )
                    )
                )
            )
        )
    )
)

(defun getValuesFromMove (move matrix)
        (setq from (getFrom move))
        (setq to (getTo move))
        (setq elTo (reverse (getNElementsOfList (reverse (getBitsByKey (list from (1- (cadar move))) matrix)) (caddr move))))
        ;; Uzima elemente koje prosledjujemo u potezu
)

(defun getMove ()
    (enterMovePrint)
    (if isPerson
        (progn
            (let*
                ((input (read)))
                (if (validate input)
                    ;(validate input isX)
                    (progn
                        (getValuesFromMove input globalMatrix)
                        (playMove input globalMatrix)
                        (displayBoard)
                    )
                    (format t "Invalide move, please try again!~%")
                )
            )
        ) ;else, bot part
        (progn
            (let*
                ((input (read)))
                (if (validate input)
                    ;(validate input isX)
                    (progn
                        (getValuesFromMove input globalMatrix)
                        (playMove input globalMatrix)
                        (displayBoard)
                    )
                    (format t "Invalide move, please try again!~%")
                )
            )
        )
    )
    (getMove)
)

(defun endOfGame ()
    (cond 
        (
            (= dimension 8)
            (if (or (= playerX 2) (= playerO 2))
                t NIL
            )
        )
        (   
            t
            (if (or (= playerX 3) (= playerO 3))
            t NIL
            )
        )
    )
)

(startGame)