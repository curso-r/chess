# basic games can be created

    Code
      game()
    Output
              <Start>
      r n b q k b n r
      p p p p p p p p
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      P P P P P P P P
      R N B Q K B N R

---

    Code
      game(fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23")
    Output
              <Start>
      r . b k . . . r
      p . . p B p N p
      n . . . . n . .
      . p . N P . . P
      . . . . . . P .
      . . . P . . . .
      P . P . K . . .
      q . . . . . b .

---

    Code
      game(headers = list(White = "Anderssen", Black = "Kieseritzky"))
    Output
              <Start>
      r n b q k b n r
      p p p p p p p p
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      P P P P P P P P
      R N B Q K B N R

---

    Code
      game(headers = list(White = "Anderssen", Black = "Kieseritzky"), fen = "r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23")
    Output
              <Start>
      r . b k . . . r
      p . . p B p N p
      n . . . . n . .
      . p . N P . . P
      . . . . . . P .
      . . . P . . . .
      P . P . K . . .
      q . . . . . b .

# basic moves can be made

    Code
      standard
    Output
           <23. Be7#>
      r . b k . . . r
      p . . p B p N p
      n . . . . n . .
      . p . N P . . P
      . . . . . . P .
      . . . P . . . .
      P . P . K . . .
      q . . . . . b .

# navigation works

    Code
      root(standard)
    Output
              <Start>
      r n b q k b n r
      p p p p p p p p
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      P P P P P P P P
      R N B Q K B N R

---

    Code
      back(standard, 5)
    Output
          <20... Na6>
      r . b . k . n r
      p . . p . p p p
      n . . B . . . .
      . p . N P N . P
      . . . . . . P .
      . . . P . Q . .
      P . P . K . . .
      q . . . . . b .

---

    Code
      forward(root(standard), 5)
    Output
             <3. Bc4>
      r n b q k b n r
      p p p p . p p p
      . . . . . . . .
      . . . . . . . .
      . . B . P p . .
      . . . . . . . .
      P P P P . . P P
      R N B Q K . N R

# branching works

    Code
      standard %>% root() %>% forward(36)
    Output
         <18... Bxg1>
      r n b . k . n r
      p . . p . p p p
      . . . B . . . .
      . p . N . N . P
      . . . . P . P .
      . . . P . Q . .
      P q P . . . . .
      R . . . . K b .

---

    Code
      standard %>% back(10)
    Output
            <18. Bd6>
      r n b . k . n r
      p . . p . p p p
      . . . B . . . .
      . p b N . N . P
      . . . . P . P .
      . . . P . Q . .
      P q P . . . . .
      R . . . . K R .

---

    Code
      standard %>% root() %>% forward(35) %>% variations()
    Output
         <18... Bxg1>      <18... Qxa1+>
      r n b . k . n r    r n b . k . n r
      p . . p . p p p    p . . p . p p p
      . . . B . . . .    . . . B . . . .
      . p . N . N . P    . p b N . N . P
      . . . . P . P .    . . . . P . P .
      . . . P . Q . .    . . . P . Q . .
      P q P . . . . .    P . P . . . . .
      R . . . . K b .    q . . . . K R .

---

    Code
      standard %>% root() %>% forward(35) %>% variation(2)
    Output
        <18... Qxa1+>
      r n b . k . n r
      p . . p . p p p
      . . . B . . . .
      . p b N . N . P
      . . . . P . P .
      . . . P . Q . .
      P . P . . . . .
      q . . . . K R .

---

    Code
      standard %>% root() %>% forward(35) %>% variation(2) %>% variations()
    Output
            <19. Ke2>          <19. Kg2>
      r n b . k . n r    r n b . k . n r
      p . . p . p p p    p . . p . p p p
      . . . B . . . .    . . . B . . . .
      . p b N . N . P    . p b N . N . P
      . . . . P . P .    . . . . P . P .
      . . . P . Q . .    . . . P . Q . .
      P . P . K . . .    P . P . . . K .
      q . . . . . R .    q . . . . . R .

---

    Code
      standard %>% root() %>% forward(35) %>% variation(2) %>% variation(2)
    Output
            <19. Kg2>
      r n b . k . n r
      p . . p . p p p
      . . . B . . . .
      . p b N . N . P
      . . . . P . P .
      . . . P . Q . .
      P . P . . . K .
      q . . . . . R .

---

    Code
      standard %>% root() %>% forward(35) %>% variation(2) %>% variation(2) %>% root()
    Output
              <Start>
      r n b q k b n r
      p p p p p p p p
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      . . . . . . . .
      P P P P P P P P
      R N B Q K B N R

