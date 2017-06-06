# Gramática

### Ejemplo de uso

    const m = 7, n = 85, t = 6;  
    var  i,x,y,z,q,r;  
    procedure mult(x, y);
       var a, b;
      begin 
         a := x;  b := y; z := 0;
         while b > 0 do
         begin
            if odd x then z := z+a else z := z-a;
            a := 2*a;
            b := b/2;
         end;
      end
      return a;
    begin
      x := m;
      y := n;
      call mult(x, 8);
    end.

### Gramática

    1.  Σ = { "const", ";", "var", "procedure", "(", ")", ":=", "call", "?",
              "!", "begin", "end", "if", "then", "else", "while", "do", COMMA,
              PUNTO, ADDOP, MULOP, COMPARISONOPERATOR }
    2.  V = { PROGRAMA, BLOQUE, PRIMARIO, INSTRUCCION, ARGUMENTO, CONDICION,
              EXPRESION, TERM, FACTOR}
    3.  Producciones:
        1.  PROGRAMA -> BLOQUE PUNTO
        2.  BLOQUE -> (PRIMARIO)*
        3.  PRIMARIO -> ("const" (ID IGUAL NUM (COMMA ID IGUAL NUM)*) ";"
                        | "var" (ID (COMMA ID)*) ";"
                        | "procedure" ID "(" ((ARGUMENTO COMMA)* ARGUMENTO)? ")" ";" BLOQUE ";"
                        | INSTRUCCION)
        4.  INSTRUCCION -> (ID ":=" EXPRESION
                            | "call" ID "(" ((ARGUMENTO COMMA)* ARGUMENTO)? ")"
                            | "?" ID
                            | "!" EXPRESION
                            | "begin" (INSTRUCCION ";")* "end"
                            | "if" CONDICION "then" INSTRUCCION ("else" INSTRUCCION)?
                            | "while" CONDICION "do" (INSTRUCCION)*)
                            | "return" EXPRESION
        5.  ARGUMENTO -> (EXPRESION
                        | ID)
        6.  CONDICION -> ("odd" EXPRESION
                          | EXPRESION COMPARISONOPERATOR EXPRESION)
        7.  EXPRESION -> (term ADDOP expression 
                         | term )
        8.  TERM -> (factor MULOP term 
                    | factor)
        9.  FACTOR -> ('(' expression ')' 
                      | NUM)
                     
### Mejoras implementadas

    1) Añadido el else del if.
    2) Añadido la posibilidad de argumentos en funciones.
    3) Añadido el return.
    4) Comprobar que el número de argumentos pasados en la llamada es correcto.
    5) Comprobar que las variables han sido declaradas cuando son usadas.
    6) Traductor a javascript.