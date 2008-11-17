        INTEGER FUNCTION ISPRIME(X)
        INTEGER*8 LIM, Y, X
        IF(X.lt.2) THEN
            ISPRIME = 0
            RETURN
        ENDIF
        IF(X.lt.4) THEN
            ISPRIME = 1
            RETURN
        ENDIF
        IF(X.eq.5) THEN
            ISPRIME = 1
            RETURN
        ENDIF
        IF(MOD(X,2).eq.0) THEN
            ISPRIME = 0
            RETURN
        ENDIF
        IF(MOD(X,5).eq.0) THEN
            ISPRIME = 0
            RETURN
        ENDIF
        IF(MOD(X + 1, 6) .NE. 0) THEN
            IF(MOD(X - 1, 6) .NE. 0) THEN
                ISPRIME = 0
                RETURN
            ENDIF
        ENDIF
        LIM = INT(SQRT(REAL(X)) + 1.0);
        DO Y = 3, LIM, 2
            IF(MOD(X,Y).eq.0) THEN
                ISPRIME = 0
                RETURN
            ENDIF
        ENDDO
        ISPRIME = 1
        RETURN
        END

        FUNCTION GENPRIME(MX)
        INTEGER*8 CNT, CUR, MX
        CUR = 0
		CNT = 0
        DO WHILE(CNT.lt.MX)
            IF(ISPRIME(CUR).eq.1) THEN
                CNT = CNT + 1
            ENDIF
            CUR = CUR + 1
        ENDDO
        GENPRIME = CUR - 1;
        RETURN
        END

C       Doesn't have to be MAIN
        PROGRAM MAIN
          REAL TIMES, TIMET, TIME
          INTEGER*8 STRT, STP, X
          INTEGER Z
		  
          CHARACTER *20 BUFFER
          CALL GETARG(1,BUFFER)
          READ (BUFFER,*) STRT
          CALL GETARG(2,BUFFER)
          READ (BUFFER,*) STP
          
          DO X = STRT, STP, STRT
              TIMES = SECOND()
              Z = GENPRIME(X)
              TIMET = SECOND()
              TIME = TIMET - TIMES
              PRINT *,'Found ',X,' primes in ',TIME,' (last was',Z,')'
          ENDDO
		  
        END
